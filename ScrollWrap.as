package fpg
{
	import flash.net.*;  
	import flash.display.*;
	import flash.events.*;
	import flash.external.ExternalInterface;
	import fpg.*;

	/******************************
	* PhotoExpand class:
	* Extends MovieClip to act to display the selected photo. */

	public class ScrollWrap extends MovieClip 
	{
		//***************************
		// Properties:
		
		public var maskWidth			:Number;
		public var maskWidthBottom		:Number = 680;
		public var maskWidthLeft		:Number = 500;
		
		protected var bgColor			:uint = 0x333333;		

		protected var xClipping  		:Number = maskWidthBottom;
		protected var yClipping  		:Number = 100;	
		protected var scrollMask		:Sprite;
		
		public function ScrollWrap()
		{
			// Construct!
		}
		
		//***************************
		// Public methods:
		
		public function setData():void
		{

			maskWidth = xClipping;
			
			// Add a Clipping Region
			scrollMask = new Sprite();
			scrollMask.graphics.beginFill(0x000000, 0);
			scrollMask.graphics.drawRect(0, 0, xClipping, yClipping);
			scrollMask.graphics.endFill();
			addChild(scrollMask);
			mask = scrollMask;
			// End of Clipping Region
		}
		public function setClipping(maskW):void
		{
			removeChild(scrollMask);
			scrollMask = new Sprite();
			maskWidth = xClipping = maskW;
			// Add a Clipping Region

			scrollMask.graphics.beginFill(0x000000, 0);
			scrollMask.graphics.drawRect(0, 0, xClipping, yClipping);
			scrollMask.graphics.endFill();
			addChild(scrollMask);
			mask = scrollMask;
			// End of Clipping Region
		}
				
	}
}
