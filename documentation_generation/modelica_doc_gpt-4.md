# Documentation for FuelMassFlowSensor Modelica Code

## Overview

This Modelica code defines a model for a Fuel Mass Flow Rate Sensor in a combustion system. The model captures the properties of the fuel flow at the sensor's inlet and outlet and transfers the measurements as signals.

## Main Components

The model has two main components:

1. An inlet connector (`C1`), representing the point at which the fuel enters the sensor.
2. An outlet connector (`C2`), representing the point at which the fuel leaves the sensor.

Each connector has several properties reflecting the characteristics of the fuel, including its temperature, pressure, Low Heating Value (LHV), specific heat at constant pressure (cp), humidity, molar concentration of carbon (Xc), hydrogen (Xh), oxygen (Xo), nitrogen (Xn), sulphur (Xs), ashes (Xashes), molar volume (VolM), and fuel density (rho).

The model ensures that these properties are preserved between the inlet and outlet connectors.

## Mass Flow Rate

The mass flow rate (`Q`) is extracted from the inlet connector (`C1.Q`), representing the rate at which the fuel is flowing into the sensor.

## Sensor Signal

The model contains a real output connector (`Mesure`) that outputs the sensor's measurement signal, representing the fuel's mass flow rate.

## Annotation

The annotation section provides a symbolic representation of the sensor, which is displayed in a Modelica environment's user interface. It also includes documentation and copyright notices.

## Version

This code is compatible with ThermoSysPro version 2.0. 

## Author

The code was authored by Salimou Gassama.