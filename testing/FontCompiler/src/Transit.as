package
{
	import flash.display.Sprite;
	import flash.text.Font;
	
	public class Transit extends Sprite
	{
		
		[Embed(source="Transit/TransBla.otf", fontFamily="TransitBlack", embedAsCFF="true",mimeType = "application/x-font")]
		public const TransitBlack : Class;
		
		[Embed(source="Transit/TransBol.otf", fontFamily="TransitBold", embedAsCFF="true",mimeType = "application/x-font")]
		public const TransitBold : Class;
		
		[Embed(source="Transit/TransBolIta.otf", fontFamily="TransitBoldItalic", embedAsCFF="true",mimeType = "application/x-font")]
		public const TransitBoldItalic : Class;
		
		[Embed(source="Transit/TransNor.otf", fontFamily="TransitNormal", embedAsCFF="true",mimeType = "application/x-font")]
		public const TransitNormal : Class;
		
		[Embed(source="Transit/TransIta.otf", fontFamily="TransitItalic", embedAsCFF="true",mimeType = "application/x-font")]
		public const TransitItalic : Class;
		
		private static const fonts:Array = ['TransitBold','TransitBlack','TransitBoldItalic','TransitNormal','TransitItalic'];
		
		public function Transit()
		{
			super();
			var length:int = fonts.length;
			for (var i:int; i < length; i++) {
				Font.registerFont(this[fonts[i]]);
			}
		}
	}
}
