# esx_jj-tax

Tax citizens by how much they earn in your city and give back to the government jobs.

## Dependencies

mysql-async

esx_advangedgarage

### optional

mythic_notify

## Usage

1. Upload esx_jj-tax to your resources
2. Add start esx_bobbypin to your server.cfg/resources.cfg
3. Customise the config.lua to your preferences

```lua
Config.Hour = 10
Config.UseMythicNotifications = true
Config.UseVehicleTax = true
Config.UsePropertyTax = false

Config.Low = 300000
Config.High = 1000000

Config.TaxLow = 0 
Config.TaxMedium = 2
Config.TaxHigh = 5

Config.VehicleTaxLow = 0 
Config.VehicleTaxMedium = 2
Config.VehicleTaxHigh = 7

Config.PropertyTaxLow = 0 
Config.PropertyTaxMedium = 2 
Config.PropertyTaxHigh = 5
```

## License
esx_jj-tax - script for FiveM essential mode extended

Copyright (C) 2019 JayyJayy

This program Is free software: you can redistribute it And/Or modify it under the terms Of the GNU General Public License As published by the Free Software Foundation, either version 3 Of the License, Or (at your option) any later version.

This program Is distributed In the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty Of MERCHANTABILITY Or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License For more details.

You should have received a copy Of the GNU General Public License along with this program. If not, see [here](http://www.gnu.org/licenses/).
