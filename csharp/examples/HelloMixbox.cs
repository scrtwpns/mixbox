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
