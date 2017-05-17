# Copyright (C) 2016 PerfectlySoft Inc.
# Author: Shao Miller <swiftcode@synthetel.com>

FROM perfectlysoft/ubuntu1510
RUN /usr/src/Perfect-Ubuntu/install_swift.sh --sure
RUN git clone https://github.com/s/SwiftBot /usr/src/SwiftBot
WORKDIR /usr/src/SwiftBot
RUN swift build
CMD .build/debug/SwiftBot --port 80
