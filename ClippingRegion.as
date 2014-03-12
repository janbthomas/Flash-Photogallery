package fpg
{
	import flash.net.*;  
	import flash.display.*;
	import flash.net.URLRequest;
	import flash.events.*;
	import flash.external.ExternalInterface;
	import fpg.*;

	/******************************
	* PhotoExpand class:
	* Extends MovieClip to act to display the selected photo. */

	public class PhotoDetail extends MovieClip 
	{
		//***************************
		// Properties:
		
		public var data					:Object;
		public var index				:Number;
		protected var pictLdr			:Loader;
		protected var pictURL			:String;
		protected var bgColor			:uint = 0x000000;		
		protected var currentChild		:*;
		protected var photoDetailX  	:Number = 20;
		protected var landscapeY  		:Number = 50;
		protected var portraitY  		:Number = 50;
		

		public function PhotoDetail()
		{
			// Construct!
			buttonMode = true;			
			
			// Listen to mouse interactions
			addEventListener(MouseEvent.MOUSE_OVER, rollOverHandler);
			addEventListener(MouseEvent.MOUSE_OUT, rollOutHandler);
		}
		
		//***************************
		// Public methods:
		
		public function setData(o:Object):void
		{
			
			//drawBg();
			
			// Save values
			data = o;
			
			pictLdr = new Loader();
			pictURL= data.@img;
			pictLdr.load(new URLRequest(pictURL));
			pictLdr.contentLoaderInfo.addEventListener(Event.COMPLETE, imgLoaded);
			
		}
		
		protected function drawBg():void {
            graphics.beginFill(bgColor);
            graphics.drawRect(0, 0, 1000, 1000);
            graphics.endFill();
        }


		//***************************
		// Event handlers:
		protected function imgLoaded(event:Event):void
		{	
			if (currentChild != undefined)
				removeChild(currentChild);

			currentChild = pictLdr.content;
			
			// Scale
			var pictWidth: uint = currentChild.width;
			var pictHeight: uint = currentChild.height;
			var pictScale: Number = 1;
			
			trace("pictWidth: " + pictWidth);
			
			x = photoDetailX;
			if ((pictWidth / pictHeight) > 1){
				pictScale = 700/pictWidth;
				y = landscapeY;
			}
			else {
				pictScale = 500/pictHeight;
				y = portraitY;
			}
			//currentChild.scaleX = currentChild.scaleY = pictScale;

			var newMargin: uint = (800 -(pictWidth * pictScale)) / 2;
			//x = newMargin;
			
			//** Test Start
			var matrix:Object = currentChild.transform.matrix;
			matrix.scale(pictScale, pictScale);
			matrix.scale(scaleX, scaleY);
			matrix.translate(newMargin, y);
			
			currentChild.transform.matrix = matrix;
			
			var square:Sprite = new Sprite();
			square.graphics.beginFill(0xFF0000);
			square.graphics.drawRect(200, 100, 300, 200);
			addChild(square);
			
			currentChild.mask = square;

			
			//** Test End
			
			
			
			
			
			
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
