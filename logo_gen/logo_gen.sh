#!/bin/bash

# SPDX-FileCopyrightText: 2023 https://github.com/AvalonSemiconductors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# SPDX-License-Identifier: Apache-2.0
#
# NOTE: This is borrowed from here:
# https://github.com/AvalonSemiconductors/gfmpw1-multi/blob/cb9a1ee73967b7b1b0af307714f44025d43e7572/logo_gen/logo_gen.sh
# ...and that repo is offered under an Apache-2.0 license
# (ref: https://github.com/AvalonSemiconductors/gfmpw1-multi/blob/main/LICENSE)

set -e

if [ $# -ne 2 ]; then
    cat <<EOH
Usage: $0 SOURCEIMAGE TARGETMACRO
Where:
  SOURCEIMAGE is a PNG file (300~500px width recommended)
  TARGETMACRO is the name of the macro that will be generated: .gds and .lef output
EOH
fi

java LogoGen.java $1 > $2.mag
echo "extract all;ext2sim labels on;ext2sim -R -C;ext2spice scale off;ext2spice -F -R -C -f spice3;calma;lef write" | magic -T $PDK_ROOT/gf180mcuD/libs.tech/magic/gf180mcuD.tech -dnull -noconsole $2.mag
mv $2.lef ../lef
mv $2.gds ../gds
rm $2.mag $2.nodes $2.sim $2.ext $2.spice

