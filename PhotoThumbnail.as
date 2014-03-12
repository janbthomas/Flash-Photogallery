package fpg
{
	import flash.net.*;  
	import flash.display.*;
	import flash.net.URLRequest;
	import flash.events.*;
	import flash.external.ExternalInterface;
	import fpg.*;

	/******************************
	* PhotoThumbnail class:
	* Extends Graphics to act as a button for thumbnail
	* photo selection in the Flash Photo Gallery interface. */

	public class PhotoThumbnail extends MovieClip 
	{
		//***************************
		// Properties:
		
		public var data					:Object;
		public var index				:Number;
		
		protected var pictLdr			:Loader;
		protected var pictURL			:String;
		protected var bgColor			:uint = 0x333333;		

		public function PhotoThumbnail()
		{
			// Construct!
			buttonMode = true;			
		}
		
	 	protected function drawBg():void {
            graphics.beginFill(bgColor);
            graphics.drawRect(0, 0, 80, 80);
            graphics.endFill();
        }

		//***************************
		// Public methods:
		
		public function setData(i:Number, o:Object):void
		{
			// Save values
			index = i;
			data = o;
		
			drawBg();
			pictLdr = new Loader();
			pictURL= data.@thmb; //data.@thmb
			pictLdr.load(new URLRequest(pictURL));
			pictLdr.contentLoaderInfo.addEventListener(Event.COMPLETE, imgLoaded);
			// Listen to mouse interactions
			addEventListener(MouseEvent.MOUSE_OVER, rollOverHandler);
			addEventListener(MouseEvent.MOUSE_OUT, rollOutHandler);
		}
		public function getData(): Object
		{
			return data;
		}
		public function setFocus(doSet:Boolean)
		{
			if (doSet)
				gotoAndPlay(20);
			else
				gotoAndPlay(1);
		}
		
		//***************************
		// Event handlers:
		protected function imgLoaded(event:Event):void
		{
			var leftMargin:Number = (80 - pictLdr.content.width)/2;
			pictLdr.content.x = leftMargin;
			addChild(pictLdr.content); 
		}
		protected function rollOverHandler(event:MouseEvent):void
		{
			// Adjust state
			alpha = .5;
		}
		protected function rollOutHandler(event:MouseEvent):void
		{
			// Adjust state
			alpha = 1;
		}
			
	
	}
}
