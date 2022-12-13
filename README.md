# Mixbox: Pigment-Based Color Mixing

<p align="center">
  <img src="https://scrtwpns.com/mixbox/teaser.jpg"/>
</p>

Mixbox is a new blending method for natural color mixing. It produces saturated gradients with hue shifts and natural secondary colors during blending. Yellow and blue make green. The interface is simple - RGB in, RGB out. Internally, Mixbox treats colors as real-life pigments using the Kubelka & Munk theory to predict realistic color behavior. That way, colors act like actual paints and bring more vibrance and intuition into digital painting.

* Paper: https://scrtwpns.com/mixbox.pdf<br>
* Video: https://youtu.be/ATzVPVNp1qA<br>
* Talk: https://youtu.be/_qa5iWdfNKg<br>
* Demo: https://scrtwpns.com/mixbox/painter<br>

Mixbox is shipping in Rebelle 5 Pro as the [Rebelle Pigments](https://www.escapemotions.com/products/rebelle/about) feature and in the [Flip Fluids](https://flipfluids.com/) addon for Blender.

## Usage
- [C / C++](cpp): `#include "mixbox.h"` and build `mixbox.cpp` together with your project
- [C#](csharp): use Mixbox package from NuGet `https://www.nuget.org/packages/Mixbox/2.0.0`
- [Java](java): add `implementation 'com.scrtwpns:mixbox:2.0.0'` to your Gradle
- [JavaScript](javascript): `<script src="https://scrtwpns.com/mixbox.js">`
- [Node](javascript): `npm install mixbox`
- [Python](python): `pip install pymixbox`
- [Rust](rust): add `mixbox = "2.0.0"` to your Cargo.toml
- [Unity](unity): add package from git url `git://github.com/scrtwpns/mixbox.git#upm`
- [Godot](godot): copy `godot\addons` to the root of your project
- [Shaders](shaders): load `mixbox_lut.png` as texture and include `mixbox.glsl`/`.hlsl`/`.metal` code into your shader

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

## C / C++
```c++
#include <stdio.h>
#include "mixbox.h"

int main() {
  unsigned char r1 =   0, g1 = 33,  b1 = 133; // blue
  unsigned char r2 = 252, g2 = 211, b2 = 0;   // yellow
  float t = 0.5;
  unsigned char r, g, b;

  mixbox_lerp(r1, g1, b1,  // first color
              r2, g2, b2,  // second color
              t,           // mixing ratio
              &r, &g, &b); // result

  printf("%d %d %d\n", r, g, b);
}
```

## GLSL Shader
```glsl
#ifdef GL_ES
precision highp float;
#endif

uniform sampler2D mixbox_lut; // bind the "mixbox_lut.png" texture here

#include "mixbox.glsl" // paste the contents of mixbox.glsl here

void main(void) {
  vec3 rgb1 = vec3(0, 0.129, 0.522); // blue
  vec3 rgb2 = vec3(0.988, 0.827, 0); // yellow
  float t = 0.5;                     // mixing ratio

  vec3 rgb = mixbox_lerp(rgb1, rgb2, t);

  gl_FragColor = vec4(rgb, 1.0);
}
```

## Rust
```rust
fn main() {
    let rgb1 = [0, 33, 133];  // blue
    let rgb2 = [252, 211, 0]; // yellow
    let t = 0.5;              // mixing ratio

    let [r, g, b] = mixbox::lerp(&rgb1, &rgb2, t);

    println!("{} {} {}", r, g, b);
}
```

## Python
```python
import mixbox

rgb1 = (0, 33, 133)  # blue
rgb2 = (252, 211, 0) # yellow
t = 0.5              # mixing ratio

rgb_mix = mixbox.lerp(rgb1, rgb2, t)

print(rgb_mix)
```

## JavaScript
```html
<html>
  <body>
    <script src="https://scrtwpns.com/mixbox.js"></script>
    <script>
      var rgb1 = "rgb(0, 33, 133)";  // blue
      var rgb2 = "rgb(252, 211, 0)"; // yellow
      var t = 0.5;                   // mixing ratio

      var mixed  = mixbox.lerp(rgb1, rgb2, t);

      document.body.style.background = mixed;
    </script>
  </body>
</html>
```
## Node
```javascript
import mixbox from 'mixbox';

let rgb1 = "rgb(0, 33, 133)";  // blue
let rgb2 = "rgb(252, 211, 0)"; // yellow
let t = 0.5;                   // mixing ratio

let mixed  = mixbox.lerp(rgb1, rgb2, t);

console.log(mixed);
```

## Java
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
package com.example.hellomixbox;

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

## C#
```csharp
using System.Drawing;
using Scrtwpns.Mixbox;

public class HelloMixbox
{
    public static void Main(string[] args)
    {
        Color color1 = Color.FromArgb(0, 33, 133);  // blue
        Color color2 = Color.FromArgb(252, 211, 0); // yellow
        float t = 0.5f;                             // mixing ratio

        Color colorMix = Color.FromArgb(Mixbox.Lerp(color1.ToArgb(), color2.ToArgb(), t));

        System.Console.WriteLine(colorMix);
    }
}
```

## Unity
```csharp
using UnityEngine;
using Scrtwpns.Mixbox;

public class NewBehaviourScript : MonoBehaviour
{
    void Start()
    {
        Color color1 = new Color(0.0f, 0.129f, 0.522f); // blue
        Color color2 = new Color(0.988f, 0.827f, 0.0f); // yellow
        float t = 0.5f;                                 // mixing ratio

        Color colorMix = Mixbox.Lerp(color1, color2, t);

        Debug.Log(colorMix);
    }
}
```

## Unity Shader
```ShaderLab
Shader "MixboxHelloShader"
{
    Properties
    {
        _MixboxLUT ("Mixbox LUT", 2D) = "white" {} // assign "Packages/Mixbox/Textures/MixboxLUT.png"

        _Color1 ("Color 1", Color) = (0, 0.129, 0.522, 1) // blue
        _Color2 ("Color 2", Color) = (0.988, 0.827, 0, 1) // yellow
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            sampler2D _MixboxLUT;
            #include "Packages/com.scrtwpns.mixbox/ShaderLibrary/Mixbox.cginc"

            fixed4 _Color1;
            fixed4 _Color2;

            struct appdata { float4 vertex : POSITION; float2 uv : TEXCOORD0; };
            struct v2f { float2 uv : TEXCOORD0; float4 vertex : SV_POSITION; };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 mixedColor = MixboxLerp(_Color1, _Color2, i.uv.x);
                return mixedColor;
            }
            ENDCG
        }
    }
}
```

## Unity Shader Graph
<p align="center">
  <img src="https://scrtwpns.com/mixbox/unity/shadergraph_.png"/>
</p>

## Godot
```gdscript
var Mixbox = preload("res://addons/mixbox/mixbox.gd")

var color1 = Color(0.0, 0.129, 0.522) # blue
var color2 = Color(0.988, 0.827, 0.0) # yellow
var t = 0.5                           # mixing ratio

var color_mix = Mixbox.lerp(color1, color2, t)

print(color_mix)
```

## Godot Shader
```glsl
shader_type canvas_item;

uniform sampler2D mixbox_lut; // attach "addons/mixbox/mixbox_lut.png" here

uniform vec4 color1 : hint_color = vec4(0.0, 0.129, 0.522, 1.0); // blue
uniform vec4 color2 : hint_color = vec4(0.988, 0.827, 0.0, 1.0); // yellow

#include "addons/mixbox/mixbox.gdshaderinc"

void fragment() {
    COLOR = mixbox_lerp(color1, color2, UV.x);
}
```

## Godot VisualShader
<p align="center">
  <img src="https://scrtwpns.com/mixbox/godot/visualshader_.png"/>
</p>

## WebGL
```html
<script src="https://scrtwpns.com/mixbox.js"></script>
```
```javascript
var shader = `
  precision highp float;

  uniform sampler2D mixbox_lut; // bind mixbox.lutTexture(gl) here

  #include "mixbox.glsl"

  void main(void) {
    vec3 rgb1 = vec3(0, 0.129, 0.522); // blue
    vec3 rgb2 = vec3(0.988, 0.827, 0); // yellow
    float t = 0.5;                     // mixing ratio

    vec3 rgb = mixbox_lerp(rgb1, rgb2, t);

    gl_FragColor = vec4(rgb, 1.0);
  }
`;

shader = shader.replace('#include "mixbox.glsl"', mixbox.glsl());
```
```javascript
gl.useProgram(shaderProgram);
gl.activeTexture(gl.TEXTURE0);
gl.bindTexture(gl.TEXTURE_2D, mixbox.lutTexture(gl));
gl.uniform1i(gl.getUniformLocation(shaderProgram, "mixbox_lut"), 0);
```

## Examples

| Gradients | Mountains | Palette Snakes |
|:---:|:---:|:---:|
| <a href="https://scrtwpns.com/mixbox/examples/gradients.html"><img src="https://scrtwpns.com/mixbox/examples/gradients.png"/></a> | <a href="https://scrtwpns.com/mixbox/examples/mountains.html"><img src="https://scrtwpns.com/mixbox/examples/mountains.png"/></a> | <a href="https://scrtwpns.com/mixbox/examples/palette.html"><img src="https://scrtwpns.com/mixbox/examples/palette.png"/></a> |
|  [source code](javascript/examples/gradients.js) |  [source code](javascript/examples/mountains.js) |  [source code](javascript/examples/palette.js) |

| Splash Art | Paint Mixer | Pigment Fluids |
|:---:|:---:|:---:|
| <a href="https://scrtwpns.com/mixbox/examples/splash.html"><img src="https://scrtwpns.com/mixbox/examples/splash.png"/></a> | <a href="https://scrtwpns.com/mixbox/examples/mixer.html"><img src="https://scrtwpns.com/mixbox/examples/mixer.png"/></a> | <a href="https://scrtwpns.com/mixbox/fluids"><img src="https://scrtwpns.com/mixbox/examples/fluids.png"/></a> |
|  [source code](javascript/examples/splash.html) |  [source code](javascript/examples/mixer.js) |  [source code](https://scrtwpns.com/mixbox/fluids/script.js) |

## Painter
<p align="center">
  <a href="https://scrtwpns.com/mixbox/painter"><img src="https://scrtwpns.com/mixbox/painter_git.jpg"/></a>
</p>
This painting app runs two color mixing implementations in parallel: one based on Mixbox and the other that performs ordinary RGB mixing. The app allows switching between them on the fly, showing the differences between pigment-based mixing and the normal RGB mixing. To launch the painter in your browser, please <a href="https://scrtwpns.com/mixbox/painter">click here</a>.

## License
Copyright (c) 2022, Secret Weapons. All rights reserved.<br>
Mixbox is provided under the CC BY-NC 4.0 license for non-commercial use only.<br>
If you want to obtain commercial license, please contact: mixbox@scrtwpns.com
