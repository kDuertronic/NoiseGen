#include <peripherals.h>

Adafruit_SH1106 Display(OLED_RESET);                        // constructor for I2C OLED display

/*          LED GPIO SERVICE ROUTINE        */

void configure_leds()                                       // configuring LEDS as digital outputs
{
    pinMode(LED_G, OUTPUT);
    pinMode(LED_R, OUTPUT);
    set_led_state(LED_G, OFF);
    set_led_state(LED_R, OFF);
}

void set_led_state(uint8_t led_pin, led_state_t state)      // setting LED's state
{
    digitalWrite(led_pin, state);
}

void led_selftest_at_boot(uint8_t cycles)                   // LEDs selftest at every boot
{
    for(int i = 0; i < cycles; i++)
    {
        set_led_state(LED_G, ON);
        set_led_state(LED_R, ON);
        vTaskDelay(pdMS_TO_TICKS(500));
        set_led_state(LED_G, OFF);
        set_led_state(LED_R, OFF);
        vTaskDelay(pdMS_TO_TICKS(500));
    }
}

/*          I2C BUS SERVICE ROUTINE (OLED)    */

uint8_t scan_i2c_bus()                 // I2C device address scanner
{
    error_t error = 0;

    for(uint8_t address = 0x01; address < 0x7F; address++)
    {
        Wire.beginTransmission(address);
        error = Wire.endTransmission();

        if(error == 0)      return address;
    }

    return 0;   // none of devices found
}

void oled_init(i2c_clock_t bus_clock)                                            // OLED initialization
{
    Wire.begin(OLED_SDA, OLED_SCL, bus_clock);
    vTaskDelay(pdMS_TO_TICKS(10));
    uint8_t oled_address = scan_i2c_bus();
    if(oled_address == 0)       return;

    Display.begin(SH1106_SWITCHCAPVCC, oled_address);
    vTaskDelay(pdMS_TO_TICKS(1000));

    Display.clearDisplay();
    Display.display();

    Display.setTextColor(WHITE);
    Display.setTextSize(1);
    Display.setCursor(25, 1);
    Display.print("NoiseGen v1.1");
    Display.display();
    vTaskDelay(pdMS_TO_TICKS(1200));
}