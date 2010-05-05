package com.mapx.view.tools
{
	import flash.geom.Rectangle;
	import flash.text.engine.TextLine;
	
	import flashx.textLayout.compose.TextFlowLine;
	import flashx.textLayout.elements.ParagraphElement;
	import flashx.textLayout.elements.SpanElement;
	import flashx.textLayout.elements.TextFlow;
	
	import mx.core.UIComponent;
	
	import textEditBar.SingleContainerView;

	public class TLFUtils
	{
		public static function spanBBox(span:SpanElement,abs:int,rel:int,len:int,activeFlow:TextFlow,textPanel:SingleContainerView):Rectangle
		{
			var p:ParagraphElement =span.getParagraph();
			var line:TextFlowLine = activeFlow.flowComposer.findLineAtPosition(abs);
			var line2:TextFlowLine = activeFlow.flowComposer.findLineAtPosition(abs+len);
			var textLine:TextLine = line.getTextLine();
			var textLine2:TextLine = line2.getTextLine();	
			var atomIndex1:int = textLine.getAtomIndexAtCharIndex(rel);
			var atomIndex2:int = textLine2.getAtomIndexAtCharIndex(rel+len); 
			var r1:Rectangle = textLine.getBounds(textPanel);
			
			var bbox1:Rectangle = textLine.getAtomBounds(atomIndex1); // span.getAbsoluteSta	rt()+length
			var bbox2:Rectangle  = textLine2.getAtomBounds(atomIndex2);
			bbox1.y = r1.y; bbox1.height = r1.height; bbox1.width = bbox2.x - bbox1.x;
			bbox1.x += textLine.x;
			return bbox1;	
		}
		public static function highlightBlock(item:Object,color:uint,sprite:UIComponent,activeFlow:TextFlow,textPanel:SingleContainerView):void
		{
			var span:SpanElement = activeFlow.findLeaf(item.start) as SpanElement;
			var relativePosition:int = item.start - span.getParagraph().getAbsoluteStart();	
			var bbox:Rectangle = spanBBox(span,item.start,relativePosition,item.length,activeFlow,textPanel);		
			sprite.graphics.moveTo(bbox.x,bbox.y);
			sprite.graphics.lineStyle(2,color,1,true);
			sprite.graphics.lineTo(bbox.x+bbox.width,bbox.y);
			sprite.graphics.lineTo(bbox.x+bbox.width,bbox.y+bbox.height);
			sprite.graphics.lineTo(bbox.x,bbox.y+bbox.height);
			sprite.graphics.lineTo(bbox.x,bbox.y);
			//textPanel.verticalScrollPosition = item.start,item.start+item.length;
			/*	if(bbox.y+bbox.height > editorHolder.height+ editorHolder.verticalScrollPosition)
			editorHolder.verticalScrollPosition = bbox.y;
			else if(bbox.y < editorHolder.verticalScrollPosition)
			editorHolder.verticalScrollPosition = bbox.y;*/
		}
	}
}