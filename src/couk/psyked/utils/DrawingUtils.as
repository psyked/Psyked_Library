package couk.psyked.utils
{
    import flash.display.Graphics;


    public class DrawingUtils
    {
        public function DrawingUtils()
        {
        }

        public static function drawArc( graphics:Graphics, centerX:Number, centerY:Number, radius:Number, startAngle:Number, arcAngle:Number, steps:int ):void
        {
            var twoPI:Number = 2 * Math.PI;
            var angleStep:Number = arcAngle / steps;
            var xx:Number = centerX + Math.cos( startAngle * twoPI ) * radius;
            var yy:Number = centerY + Math.sin( startAngle * twoPI ) * radius;
            graphics.moveTo( xx, yy );
            for ( var i:int = 1; i <= steps; i++ )
            {
                var angle:Number = startAngle + i * angleStep;
                xx = centerX + Math.cos( angle * twoPI ) * radius;
                yy = centerY + Math.sin( angle * twoPI ) * radius;
                graphics.lineTo( xx, yy );
            }
        }
    }
}