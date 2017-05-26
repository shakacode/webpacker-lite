# Change Log
All notable changes to this project's source code will be documented in this file. Items under `Unreleased` is upcoming features that will be out in next version. NOTE: major versions of the npm module and the gem must be kept in sync.

Contributors: please follow the recommendations outlined at [keepachangelog.com](http://keepachangelog.com/). Please use the existing headings and styling as a guide, and add a link for the version diff at the bottom of the file. Also, please update the `Unreleased` link to compare to the latest release version.

## [Unreleased]
*Please add entries here for your pull requests.*

### Changed
* Added better error messages for missing files.
* Added api to check if the manifest exists

## [2.0.0] - 2017-05-23
All in [#9](https://github.com/shakacode/webpacker_lite/pull/9) by [justin808](https://github.com/justin808) with help from [conturbo](https://github.com/conturbo) on the tests.

* Rewrote README.md.
* Configuration is simplified and changed to a single file, `/config/webpacker_lite.yml`. See README.md.
* v1 assumed that manifest.json would contain the host name for hot reloading. v2 puts in the host at the Ruby level.
* `stylesheet_pack_tag` API changed. ENV value for `HOT_RELOADING` == "TRUE" results in the stylesheet_pack_tag not writing anything due to hot reloading requiring inlined JavaScript of styles and not extracted CSS.
* Removed any bits of JavaScript from webpacker_lite.
* Added tests

## [1.0.0] - 2017-05-03
Initial release

[Unreleased]: https://github.com/shakacode/webpacker_lite/compare/2.0.0...master
[2.0.0]: https://github.com/shakacode/react_on_rails/compare/1.0.0...2.0.0
[1.0.0]: https://github.com/shakacode/react_on_rails/compare/0.0.5...1.0.0
