package fpg
{
	import flash.net.*;  
	import flash.display.*;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.events.*;
	import flash.external.ExternalInterface;
	import fpg.*;

	/******************************
	* PhotoExpand class:
	* Extends MovieClip to act to display the selected photo. */

	public class ThumbScroll extends MovieClip 
	{
		//***************************
		// Properties:
		
		public var data					:Object;	
		public var scrollingNext		:Boolean = false;
		public var scrollingPrevious	:Boolean = false;
		public var maxScrollWidth		:Number = 0;
		public var maskWidth			:Number;
		
		protected var bgColor			:uint = 0x333333;		
        private var dx					:Number = 2.5;
		
		public function ThumbScroll()
		{
			// Construct!
			buttonMode = true;			
			
			// Listen to mouse interactions
			addEventListener(MouseEvent.MOUSE_OVER, rollOverHandler);
			addEventListener(MouseEvent.MOUSE_OUT, rollOutHandler);
			addEventListener(Event.ENTER_FRAME,onEnterFrame);
		}
		
		//***************************
		// Public methods:
		
		public function setData(maxWidth, maskW):void
		{
			maskWidth = maskW;
			maxScrollWidth = maxWidth;
		}
		public function scrollToPos(xPos)
		{
			this.x -= xPos;
		}
	
		//***************************
		// Protected methods:
		protected function drawBg():void {
            graphics.beginFill(bgColor);
            graphics.drawRect(0, 0, 1000, 1000);
            graphics.endFill();
        }


		//***************************
		// Event handlers:
		protected function rollOverHandler(event:MouseEvent):void
		{
			// Adjust state
		}
		protected function rollOutHandler(event:MouseEvent):void
		{
			// Adjust state
		}
		private function onEnterFrame(e:Event):void
		{
			if (scrollingNext && ((x + dx + width) >= maskWidth))
			{
				this.x -= dx;
			}
			else if (scrollingPrevious && x < 0)
			{
				this.x += dx;
			}
		}

	}
}
