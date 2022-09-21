# Mixbox for Java

```java
import java.awt.Color;
import com.scrtwpns.Mixbox;

class HelloMixbox {
    public static void main(String[] args) {
        Color color1 = new Color(0, 33, 133);  // blue
        Color color2 = new Color(252, 211, 0); // yellow
        float t = 0.5f;                        // mixing ratio

        Color colorMix = new Color(Mixbox.lerp(color1.getRGB(), color2.getRGB(), t));

        System.out.print(colorMix);
    }
}
```

## Android
```java
package com.example.mixboxhelloworld;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.graphics.Color;

import com.scrtwpns.Mixbox;

public class MainActivity extends Activity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        int color1 = Color.rgb(0, 33, 133);  // blue
        int color2 = Color.rgb(252, 211, 0); // yellow
        float t = 0.5f;                      // mixing ratio

        int colorMix = Mixbox.lerp(color1, color2, t);

        View view = new View(this);
        view.setBackgroundColor(colorMix);
        setContentView(view);
    }
}
```

## Mixing Multiple Colors
```java
int mixThree(int color1, int color2, int color3) {
    float[] z1 = Mixbox.rgbToLatent(color1);
    float[] z2 = Mixbox.rgbToLatent(color2);
    float[] z3 = Mixbox.rgbToLatent(color3);

    float[] zMix = new float[Mixbox.LATENT_SIZE];

    for(int i = 0; i < zMix.length; i++) {
      // mix 30% of color1, 60% of color2, and 10% of color3
      zMix[i] = 0.3f*z1[i] + 0.6f*z2[i] + 0.1f*z3[i];
    }

    return Mixbox.latentToRgb(zMix);
}
```

## Maven
```xml
<dependency>
  <groupId>com.scrtwpns</groupId>
  <artifactId>mixbox</artifactId>
  <version>2.0.0</version>
  <type>jar</type>
</dependency>
```

## Gradle
```groovy
implementation 'com.scrtwpns:mixbox:2.0.0' // Groovy
```
```kotlin
implementation("com.scrtwpns:mixbox:2.0.0") // Kotlin
```

## Pigment Colors
| Pigment |  | RGB | Float RGB | Linear RGB |
| --- | --- |:----:|:----:|:----:|
| Cadmium Yellow | <img src="https://scrtwpns.com/mixbox/pigments/cadmium_yellow.png"/> | 254, 236, 0  | 0.996, 0.925, 0.0 | 0.991, 0.839, 0.0 |
| Hansa Yellow | <img src="https://scrtwpns.com/mixbox/pigments/hansa_yellow.png"/> | 252, 211, 0  | 0.988, 0.827, 0.0 | 0.973, 0.651, 0.0 |
| Cadmium Orange | <img src="https://scrtwpns.com/mixbox/pigments/cadmium_orange.png"/> | 255, 105, 0  | 1.0, 0.412, 0.0 | 1.0, 0.141, 0.0 |
| Cadmium Red | <img src="https://scrtwpns.com/mixbox/pigments/cadmium_red.png"/> | 255, 39, 2  | 1.0, 0.153, 0.008 | 1.0, 0.02, 0.001 |
| Quinacridone Magenta | <img src="https://scrtwpns.com/mixbox/pigments/quinacridone_magenta.png"/> | 128, 2, 46  | 0.502, 0.008, 0.18 | 0.216, 0.001, 0.027 |
| Cobalt Violet | <img src="https://scrtwpns.com/mixbox/pigments/cobalt_violet.png"/> | 78, 0, 66  | 0.306, 0.0, 0.259 | 0.076, 0.0, 0.054 |
| Ultramarine Blue | <img src="https://scrtwpns.com/mixbox/pigments/ultramarine_blue.png"/> | 25, 0, 89  | 0.098, 0.0, 0.349 | 0.01, 0.0, 0.1 |
| Cobalt Blue | <img src="https://scrtwpns.com/mixbox/pigments/cobalt_blue.png"/> | 0, 33, 133  | 0.0, 0.129, 0.522 | 0.0, 0.015, 0.235 |
| Phthalo Blue | <img src="https://scrtwpns.com/mixbox/pigments/phthalo_blue.png"/> | 13, 27, 68  | 0.051, 0.106, 0.267 | 0.004, 0.011, 0.058 |
| Phthalo Green | <img src="https://scrtwpns.com/mixbox/pigments/phthalo_green.png"/> | 0, 60, 50  | 0.0, 0.235, 0.196 | 0.0, 0.045, 0.032 |
| Permanent Green | <img src="https://scrtwpns.com/mixbox/pigments/permanent_green.png"/> | 7, 109, 22  | 0.027, 0.427, 0.086 | 0.002, 0.153, 0.008 |
| Sap Green | <img src="https://scrtwpns.com/mixbox/pigments/sap_green.png"/> | 107, 148, 4  | 0.42, 0.58, 0.016 | 0.147, 0.296, 0.001 |
| Burnt Sienna | <img src="https://scrtwpns.com/mixbox/pigments/burnt_sienna.png"/> | 123, 72, 0  | 0.482, 0.282, 0.0 | 0.198, 0.065, 0.0 |

## License
Copyright (c) 2022, Secret Weapons. All rights reserved.<br>
Mixbox is provided under the CC BY-NC 4.0 license for non-commercial use only.<br>
If you want to obtain commercial license, please contact: mixbox@scrtwpns.com
