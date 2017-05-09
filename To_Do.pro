APP_NAME = To_Do

CONFIG += qt warn_on debug_and_release cascades10

LIBS += -lbbdata
LIBS += -lbbsystem
LIBS += -lbbplatform
include(config.pri)



device {
    CONFIG(debug, debug|release) {
        # Device-Debug custom configuration
          DESTDIR = o.le-v7-g
    }

    CONFIG(release, debug|release) {
        # Device-Release custom configuration
       
    }
}

simulator {
    CONFIG(debug, debug|release) {
        # Simulator-Debug custom configuration
    }
}

