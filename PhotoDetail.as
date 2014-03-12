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
		public var leftMargin			:Number;
		public var topMargin			:Number;
		public var centerVertical		:Boolean;
		
		protected var pictLdr			:Loader;
		protected var pictURL			:String;
		protected var bgColor			:uint = 0x000000;		
		protected var currentChild		:*;
		protected var xClipping  		:Number = 750;
		protected var yClipping  		:Number = 485;
		protected var landscapeW		:Number = 745;
		protected var portraitH			:Number = 500;
		protected var canvasW			:Number = 810;
		protected var canvasH			:Number = 630;
		protected var wait				:Wait;
		

		public function PhotoDetail()
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
		public function setWait(): void
		{
			wait = new Wait();
			parent.addChild(wait);
			wait.visible = false;
			wait.scaleX = wait.scaleY = .3;
			wait.alpha = .75;
			wait.x = (parent.width - wait.width) / 2;
			wait.y = (parent.height - wait.height) / 2;
		}
		
		public function displayPicture(o:Object):void
		{
			wait.visible = true;
			
			// Save values
			data = o;
			
			pictLdr = new Loader();
			pictURL= data.@img;
			pictLdr.load(new URLRequest(pictURL));
			pictLdr.contentLoaderInfo.addEventListener(Event.COMPLETE, imgLoaded);
			
		}
		
		public function setPhotoDetail(detailX, detailY, centerV = false)
		{
			x = leftMargin = detailX;
			y = topMargin = detailY;
			centerVertical = centerV;
			
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
			alpha = .5;
			alpha = 0;
			
			if (currentChild != undefined)
				removeChild(currentChild);

			currentChild = pictLdr.content;
			
			// Scale
			var pictWidth: uint = currentChild.width;
			var pictHeight: uint = currentChild.height;
			var pictScale: Number = 1;
						
			if ((pictWidth / pictHeight) > 1){
				pictScale = (landscapeW-leftMargin)/pictWidth;
			}
			else {
				pictScale = (portraitH+leftMargin)/pictHeight;
			}
			currentChild.scaleX = currentChild.scaleY = pictScale;

			var newLeftMargin: Number = ((canvasW-leftMargin) -(pictWidth * pictScale)) / 2;
			var newTopMargin: Number = (centerVertical==true) ? ((canvasH-topMargin) - (pictHeight * pictScale)) / 2 : 0;

			x = newLeftMargin > 0 ? (newLeftMargin + leftMargin) : leftMargin;			
			y = newTopMargin > 0 ? (newTopMargin + topMargin) : topMargin;
			
			// Add a Clipping Region
			var square:Sprite = new Sprite();
			square.graphics.beginFill(0x000000, 0);
			square.graphics.drawRect(0, 0, xClipping, yClipping+leftMargin);
			addChild(square);
			currentChild.mask = square;
			// End of Clipping Region
			
			wait.visible = false;
			addChild(pictLdr.content);
			
			gotoAndPlay(2);
		}
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
			if (currentFrame != 1){
				if (currentFrame == 2)
					this.alpha = 0;
				this.alpha += .025;
			}
		}
			
	
	}
}
