// SPDX-FileCopyrightText: 2023 Efabless Corporation

// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at

//      http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.


#include <firmware_apis.h> // include required APIs
void main(){
   // Enable managment gpio as output to use as indicator for finishing configuration 
   ManagmentGpio_outputEnable();
   ManagmentGpio_write(0);
   enableHkSpi(0); // disable housekeeping spi

   GPIOs_configure(6, GPIO_MODE_USER_STD_INPUT_NOPULL); // rst
   GPIOs_configure(7, GPIO_MODE_USER_STD_INPUT_NOPULL); // ext interrupt

   GPIOs_configure(8, GPIO_MODE_USER_STD_INPUT_NOPULL); // data bus
   GPIOs_configure(9, GPIO_MODE_USER_STD_INPUT_NOPULL);
   GPIOs_configure(10, GPIO_MODE_USER_STD_INPUT_NOPULL);
   GPIOs_configure(11, GPIO_MODE_USER_STD_INPUT_NOPULL);
   GPIOs_configure(12, GPIO_MODE_USER_STD_INPUT_NOPULL);
   GPIOs_configure(13, GPIO_MODE_USER_STD_INPUT_NOPULL);
   GPIOs_configure(14, GPIO_MODE_USER_STD_INPUT_NOPULL);
   GPIOs_configure(15, GPIO_MODE_USER_STD_INPUT_NOPULL);


   GPIOs_configure(16, GPIO_MODE_USER_STD_BIDIRECTIONAL); // P0
   GPIOs_configure(17, GPIO_MODE_USER_STD_BIDIRECTIONAL);
   GPIOs_configure(18, GPIO_MODE_USER_STD_BIDIRECTIONAL);
   GPIOs_configure(19, GPIO_MODE_USER_STD_BIDIRECTIONAL);
   GPIOs_configure(20, GPIO_MODE_USER_STD_BIDIRECTIONAL);
   GPIOs_configure(21, GPIO_MODE_USER_STD_BIDIRECTIONAL);
   GPIOs_configure(22, GPIO_MODE_USER_STD_BIDIRECTIONAL);
   GPIOs_configure(23, GPIO_MODE_USER_STD_BIDIRECTIONAL);

   GPIOs_configure(24, GPIO_MODE_USER_STD_BIDIRECTIONAL); // P1
   GPIOs_configure(25, GPIO_MODE_USER_STD_BIDIRECTIONAL);
   GPIOs_configure(26, GPIO_MODE_USER_STD_BIDIRECTIONAL);
   GPIOs_configure(27, GPIO_MODE_USER_STD_BIDIRECTIONAL);

   GPIOs_configure(28, GPIO_MODE_USER_STD_OUTPUT); // Addr bus
   GPIOs_configure(29, GPIO_MODE_USER_STD_OUTPUT);
   GPIOs_configure(30, GPIO_MODE_USER_STD_OUTPUT);
   GPIOs_configure(31, GPIO_MODE_USER_STD_OUTPUT);
   GPIOs_configure(32, GPIO_MODE_USER_STD_OUTPUT);
   GPIOs_configure(33, GPIO_MODE_USER_STD_OUTPUT);
   GPIOs_configure(34, GPIO_MODE_USER_STD_OUTPUT);
   GPIOs_configure(35, GPIO_MODE_USER_STD_OUTPUT);
   GPIOs_configure(36, GPIO_MODE_USER_STD_OUTPUT);
   GPIOs_configure(37, GPIO_MODE_USER_STD_OUTPUT);

   GPIOs_loadConfigs();
   ManagmentGpio_write(1); // configuration finished 

   return;
}
