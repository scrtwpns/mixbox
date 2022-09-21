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
