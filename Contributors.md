# Introduction #

All the details to work, contribute, etc. on the source code.

gaforflash have to support different targets and can have
a little more complex workflow than your daily flash project ;)


# Environment Setup #

You can use different IDE (Flex Builder, Eclipse + Flex Builder plugin, + FDT, etc.)

You will need to checkout the source code more than once

here the basic
```

# to maintain branches and tags
$svn co https://gaforflash.googlecode.com/svn gaforflash-svn

# to work on the common library and run the unit tests
$svn co https://gaforflash.googlecode.com/svn/trunk GA_AS3

# to work on the Flash CS3 target
$svn co https://gaforflash.googlecode.com/svn/trunk GA_FLASH

# to work on the Flex Builder 3 target
$svn co https://gaforflash.googlecode.com/svn/trunk GA_FLEX

```

for Flex Builder you will need to create 3 projects
```

GA_AS3   - ActionScript project
GA_FLASH - ActionScript project
GA_FLEX  - Flex project

```

in each project properties in ActionScript build path

add this in source path
```
tests/GAv4
```

add these in library path
```
libs/maashaack.swc
libs/ASTUce.swc
```
(those libraries are only required to run the unit tests)