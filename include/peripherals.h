#ifndef PERIPHERALS_H
#define PERIPHERALS_H

#include <Arduino.h>
#include <Wire.h>
#include <Adafruit_SH1106.h>
#include <Adafruit_SSD1306.h>

/*          PIN MACROS                  */

#define LED_G 27                            // pin for GREEN LED 
#define LED_R 14                            // pin for RED LED

#define OLED_SDA 21                         // pin for SDA connection
#define OLED_SCL 22                         // pin for SCL connection
#define OLED_RESET 0

/*          USER TYPEDEFS               */

typedef enum                                // typedef for LED state determining
{
    OFF = 0,
    ON = 1,
} led_state_t;

typedef enum                                // typedef for I2C bus speed
{
    STANDARD = 100000,
    FAST     = 400000
} i2c_clock_t;

/*          FUNCTIONS PROTOTYPES        */

uint8_t scan_i2c_bus();
void oled_init(i2c_clock_t);
void configure_leds();
void set_led_state(uint8_t, led_state_t);
void led_selftest_at_boot(uint8_t);

#endif