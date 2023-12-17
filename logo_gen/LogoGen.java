// SPDX-FileCopyrightText: 2023 https://github.com/AvalonSemiconductors
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
// SPDX-License-Identifier: Apache-2.0

// NOTE: This is borrowed from here:
// https://github.com/AvalonSemiconductors/gfmpw1-multi/blob/cb9a1ee73967b7b1b0af307714f44025d43e7572/logo_gen/LogoGen.java
// ...and that repo is offered under an Apache-2.0 license
// (ref: https://github.com/AvalonSemiconductors/gfmpw1-multi/blob/main/LICENSE)


import java.io.*;
import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;

public class LogoGen {
	private LogoGen() {}
	
	private static void draw(int x1, int y1, int x2, int y2) {
		int minx = Math.min(x1, x2);
		int miny = Math.min(y1, y2);
		int maxx = Math.max(x1, x2);
		int maxy = Math.max(y1, y2);
		System.out.println(String.format("rect %d %d %d %d", minx, miny, maxx, maxy));
	}
	
	public static void main(String[] args) {
		if(args.length < 1) {
			System.err.println("Need to provide image file");
			System.exit(1);
			return;
		}
		int scale = 18;
		int gndx = 129;
		int gndy = 36;
		int powerx = 320;
		int powery = 191;
		int portSize = 100;
		try {
			BufferedImage img = ImageIO.read(new File(args[0]));
			System.out.println("magic");
			System.out.println("tech gf180mcuD");
			System.out.println("timestamp 1638034600");
			System.out.println("<< obsm2 >>");
			draw(0, img.getHeight() * scale, img.getWidth() * scale, 0);
			System.out.println("<< obsm3 >>");
			draw(0, img.getHeight() * scale, img.getWidth() * scale, 0);
			System.out.println("<< metal4 >>");
			for(int i = 0; i < img.getWidth(); i++) {
				for(int j = 0; j < img.getHeight(); j++) {
					int color = img.getRGB(i, img.getHeight() - 1 - j) & 0xFF;
					if(color < 64) continue;
					draw(i * scale, (j + 0) * scale, i * scale + scale, (j + 1) * scale);
				}
			}
			System.out.println("<< labels >>");
			gndy = img.getHeight() - gndy - 1;
			powery = img.getHeight() - powery - 1;
			gndx *= scale;
			gndy *= scale;
			powerx *= scale;
			powery *= scale;
			System.out.println(String.format("flabel metal4 s %d %d %d %d 0 FreeSans 240 0 0 0 vss", gndx, gndy, gndx + portSize, gndy + portSize));
			System.out.println("port 1 nsew ground bidirectional abutment");
			System.out.println(String.format("flabel metal4 s %d %d %d %d 0 FreeSans 240 0 0 0 vdd", powerx, powery, powerx + portSize, powery + portSize));
			System.out.println("port 2 nsew power bidirectional abutment");
			System.out.println("<< end >>");
		}catch(Exception e) {
			e.printStackTrace();
			System.exit(1);
		}
	}
}

