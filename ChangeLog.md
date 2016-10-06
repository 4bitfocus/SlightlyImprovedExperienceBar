# Slightly Improved Experience Bar Changelog

## Version 2.21
* Fixed an issue with RefreshLabel
* Updated LibAddonMenu to version 2.0 r21 (again)

## Version 2.20
* Updated the API version number
* Updated LibAddonMenu to version 2.0 r21

## Version 2.19
* Converted from Veteran Ranks to Champion Points
* Fixed label position option for xp text so that it can optionally show below the bar
* Updated the API version number
* Updated LibAddonMenu to version 2.0 r20

## Version 2.18
* Fixed display issue with maximum champion xp
* Updated the API version number

## Version 2.17
* Updated the API version number

## Version 2.16
* Updated LibAddonMenu to version 2.0 r18
* Updated LibStub to version 1.0 r4
* Hide current/maximum text when at veteran rank 14

## Version 2.15
* Updated LibAddonMenu to version 2.0 r17
* Added initial support for Champion XP

## Version 2.14
* Updated LibAddonMenu to version 2.0 r16

## Version 2.13
* Updated API version number for 1.5
* Updated LibAddonMenu

## Version 2.12
* Increased maximum allowable time for gain duration to 60 seconds
* Divided veteran rank experience by 1000 so it fits better above the experience bar
* Reintroduced support for the alpha transparency
* Updated API version number for 1.4

## Version 2.11
* Updated API version number for 1.3

## Version 2.10
* Updated optional dependencies in manifest file
* Fixed compatibility issue with Azurah

## Version 2.9
* Fixed veteran disappearing bug

## Version 2.8
* Temporary fix for the disappearing veteran progress bar bug

## Version 2.7
* Added option to move the text label below the experience bar (should help with those at veteran rank)
* Attempt to fix the disappearing bar upon XP gain
* KNOWN ISSUE: The alpha transparency no longer works

## Version 2.6
* Fixed the issue where the experience bar would not always stay displayed

## Version 2.5
* Bug fix for LibAddonMenu bug

## Version 2.4
* A few bug fixes for new API changes

## Version 2.3
* Updated to LibAddonMenu-2.0
* Added compatibility for LightWeightMinimap

## Version 2.2
* Transparency value is now properly reset after hiding bar

## Version 2.1
* Updated API version for 1.1.2
* Fixed regular experience display at level 50

## Version 2.0
* Removed hidden window OnUpdate handler in place of OnHide/OnShow event handlers (should lessen the addon's impact to FPS)
* Add label to show amount of xp gained below the bar

## Version 1.6
* Made an attempt at fixing the veteran point display
* Added option to display regular experience even after level 50

## Version 1.5
* Added option to always display the experience bar during quest turn-ins

## Version 1.4
* Setting transparency slider to 0 will mimic default behavior
* Added experimental support for veteran points to text label

## Version 1.3
* Handled the case where UI updates are fired before the addon is initialized

## Version 1.2
* Added in-game configuration panel

## Version 1.1
* Experience bar now hides when map is displayed and during crafting sessions
* Made OnUpdate handler more efficient

## Version 1.0
* Initial version
