package fpg
{
	import flash.net.*;  
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.geom.*
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.external.ExternalInterface;
	import flash.net.navigateToURL;
    import flash.net.URLRequest;

	import fpg.*;

	public class FlashPhotoGallery extends MovieClip
	{
		//***************************
		// HTTP:
		
		protected var loader					:URLLoader;
		protected var photosXML					:XML;
		protected var photosPath				:String = "photos.xml";
		protected var thumbsTotal				:Number = 0;
		private var intervalDuration			:Number = 7000;			// duration between intervals, in milliseconds
		private var intervalId					:uint = 0;

		//Positioning Thumbs
		protected var thumbXBegin				:Number = 3;
		protected var thumbYBegin				:Number = 10; 
		protected var thumbXSpacing				:Number = 5;
		protected var thumbYSpacing				:Number = 1;
		protected var thumbsPerRow				:Number = 500;
		protected var thumbs					:Array = new Array();

		// Detail view:
		protected var photoDetail				:PhotoDetail;
		protected var photoDetailX  			:Number = 5;
		protected var photoDetailY  			:Number = 45;
		protected var photoDetailYTop 			:Number = 160;
		protected var photoDetailXSide  		:Number = 120;
		protected var photoDetailYSide 			:Number = 40;
	
		// Scroll 
		protected var scrollBase				:MovieClip;
		protected var scrollWrap				:ScrollWrap;
		protected var thumbScroll				:ThumbScroll;
		protected var thumbScrollX				:Number = 60; 
		protected var thumbScrollY				:Number = 547;		
		protected var thumbScrollXTop			:Number = 60;
		protected var thumbScrollYTop			:Number = 45;		
		protected var thumbScrollXSide			:Number = 120;
		protected var thumbScrollYSide			:Number = 32;		
		protected var scrollNextBtn				:ScrollNextBtn;
		protected var scrollPreviousBtn			:ScrollPreviousBtn;
		protected var scrollBg					:Sprite;

		// Slideshow 
		protected var nextBtn					:NextBtn;
		protected var previousBtn				:PreviousBtn;
		protected var pauseBtn					:PauseBtn;
		protected var playBtn					:PlayBtn;
		
		//Positioning Slideshow
		protected var ySlideShowBtn				:Number = 22;
		protected var xNextBtn					:Number = 764;
		protected var xPreviousBtn				:Number = 712;
		protected var xPauseBtn					:Number = 735;
		protected var xPlayBtn					:Number = 732;
	
		protected var janBThomasX				:Number = 15;
		protected var janBThomasY				:Number = 680;
		protected var janBThomasBtn				:JanBThomasBtn;
		protected var switchRightBtn			:SwitchRightBtn;
		protected var switchLeftBtn				:SwitchLeftBtn;
		protected var layoutFlg					:uint = 0;
	
		// Current thumb:
		protected var selectedItem				:*;
		
		public function FlashPhotoGallery()
		{
			
			// Load data!
			loader = new URLLoader();
			loader.load(new URLRequest(photosPath));
			loader.addEventListener(Event.COMPLETE, onDataHandler);
			
		}
		
		//***************************
		// Event handlers:
		
		// Data loaded
		protected function onDataHandler(event:Event):void
		{
			photosXML = new XML(loader.data);
			thumbsTotal = photosXML.image.length();
			trace("albumCapton title= " + photosXML.albumCaption.@title);
			galleryTitle.text = photosXML.albumCaption.@title;
			layout();
		}

		protected function thumbClickHandler(event:MouseEvent):void
		{   			
			if (intervalId) {
				clearInterval(intervalId);
				intervalId = setInterval(slideShowNext, intervalDuration);
			}
			displayPicture(event.currentTarget);
			
		}
		protected function nextClickHandler(event:MouseEvent):void
		{   			
			var currentPhoto: Number = selectedItem.index + 1;
			
			clearInterval(intervalId);
			intervalId = setInterval(slideShowNext, intervalDuration);
			if (currentPhoto >= thumbs.length)
				currentPhoto = 0;
			displayPicture(thumbs[currentPhoto]);
		}
		protected function previousClickHandler(event:MouseEvent):void
		{   			
			var currentPhoto: Number = selectedItem.index - 1;
			
			clearInterval(intervalId);
			intervalId = setInterval(slideShowNext, intervalDuration);
			if (currentPhoto < 0) 
				currentPhoto = thumbs.length - 1;
			displayPicture(thumbs[currentPhoto]);
		}
		protected function playClickHandler(event:MouseEvent):void
		{   			
			intervalId = setInterval(slideShowNext, intervalDuration);
			playBtn.visible = false;
			pauseBtn.visible = true;
		}
 		protected function pauseClickHandler(event:MouseEvent):void
		{   			
			clearInterval(intervalId);
			playBtn.visible = true;
			pauseBtn.visible = false;
			intervalId = 0;
		}
       	protected function slideShowNext():void 
		{
			var currentPhoto: Number = selectedItem.index + 1;
			
			if (currentPhoto >= thumbs.length)
				currentPhoto = 0;
			displayPicture(thumbs[currentPhoto]);
			
			
        }
		protected function overScrollNextBtn(event:MouseEvent):void
		{
			if ((thumbScroll.x + thumbScroll.width) >= scrollWrap.maskWidth)
				thumbScroll.scrollingNext = true;
			else
				thumbScroll.scrollingNext = false;
			
			thumbScroll.gotoAndPlay(1);
		}
		protected function outScrollNextBtn(event:MouseEvent):void
		{
			thumbScroll.scrollingNext = false;
		}

		protected function overScrollPreviousBtn(event:MouseEvent):void
		{
			if (thumbScroll.x <= 0)
				thumbScroll.scrollingPrevious = true;
			else
				thumbScroll.scrollingPrevious = false;
			thumbScroll.gotoAndPlay(1);
		}
		protected function outScrollPreviousBtn(event:MouseEvent):void
		{
			thumbScroll.scrollingPrevious = false;
		}
		protected function switchRightClickHandler(event:MouseEvent):void
		{   			
			switch (layoutFlg) {
			case 0: // Bottom Layout
				setTopScroll();
				break;
			case 1: // Top Layout
				setBottomScroll();
				break;
			case 2: // Side Layout
				setBottomScroll();
				break;
			}
		}
		protected function switchLeftClickHandler(event:MouseEvent):void
		{   			
			switch (layoutFlg) {
			case 0: // Bottom Layout
				setSideScroll();
				break;
			case 1: // Top Layout
				setSideScroll();
				break;
			case 2: // Side Layout
				setTopScroll();
				break;
			}
		}
		protected function janBThomasClickHandler(event:MouseEvent):void
		{   			
            var url:String = "http://www.janbthomas.com/";
            var request:URLRequest = new URLRequest(url);
            navigateToURL(request);
		}
		protected function setInitialScroll(flag:Number):void
		{   			
			if (flag < 3 && flag >= 0)
				layoutFlg = flag;
			else
				layoutFlg = flag = 0;
				
			selectedItem = thumbs[0];
			
			trace("layoutFlg: " + flag);
			
			switch (flag) {
			case 0: // Bottom Layout
				setBottomScroll();
				break;
			case 1: // Top Layout
				setSideScroll();
				break;
			case 2: // Side Layout
				setTopScroll();
				break;
			}
		}
		
		protected function setTopScroll():void
		{
			layoutFlg = 1;
			scrollBase.x =  8;
			scrollBase.rotation = 0;
			scrollBase.y =  thumbScrollYTop;

			scaleScrollBg(false);
			scrollWrap.y = 0;
			scrollWrap.setClipping(scrollWrap.maskWidthBottom);
			thumbScroll.maskWidth = scrollWrap.maskWidthBottom;
			scrollNextBtn.x = thumbScrollX + scrollWrap.maskWidth + 17;
			switchRightBtn.x = thumbScrollX + scrollWrap.maskWidth + 43;
			rotateThumbs(0);
			
			photoDetail.setPhotoDetail(photoDetailX, photoDetailYTop);
			displayPicture(thumbs[selectedItem.index]);				
		}
		protected function setBottomScroll():void
		{
			layoutFlg = 0;

			scrollBase.rotation = 0;
			scrollBase.x = 7;
			scrollBase.y = thumbScrollY;
			scaleScrollBg(false);
			scrollWrap.y = 0;
			scrollWrap.setClipping(scrollWrap.maskWidthBottom);
			thumbScroll.maskWidth = scrollWrap.maskWidthBottom;
			scrollNextBtn.x = thumbScrollX + scrollWrap.maskWidth + 17;
			switchRightBtn.x = thumbScrollX + scrollWrap.maskWidth + 43;
			rotateThumbs(0);

			photoDetail.setPhotoDetail(photoDetailX, photoDetailY);
			displayPicture(thumbs[selectedItem.index]);				
		}
		protected function setSideScroll():void
		{
			layoutFlg = 2;
			scrollWrap.setClipping(scrollWrap.maskWidthLeft);
			thumbScroll.maskWidth = scrollWrap.maskWidthLeft;
			scrollNextBtn.x = thumbScrollX + scrollWrap.maskWidth + 17;
			switchRightBtn.x = thumbScrollX + scrollWrap.maskWidth + 43;
			
			scrollBase.rotation = 90;
			scrollBase.x = thumbScrollXSide;
			scrollBase.y = thumbScrollYSide;
			scaleScrollBg(true);
			photoDetail.setPhotoDetail(photoDetailXSide, photoDetailYSide, true);
			displayPicture(thumbs[selectedItem.index]);				
			scrollWrap.y = 7;
			rotateThumbs(-90);
		}
		
		//***************************
		// Layout:
			
		protected function layout():void
		{
			
			// 5. DETAIL VIEW (Create detail clip below thumbnails)
			photoDetail = new PhotoDetail();
			photoDetail.setPhotoDetail(photoDetailX, photoDetailY);
			photoDetail.visible = false;
			addChild(photoDetail);
			photoDetail.setWait();

			// THUMBSCROLL
			scrollBase = new MovieClip();
			scrollBase.x = 0;
			scrollBase.y = thumbScrollY;
			addChild(scrollBase);
			drawScrollBg();

			scrollWrap = new ScrollWrap();
			scrollWrap.x = thumbScrollX;
			scrollWrap.setData();
			scrollBase.addChild(scrollWrap);
			
			thumbScroll = new ThumbScroll();
			thumbScroll.x = 0;
			thumbScroll.y = 0;
						
			createScrollBtns();
			createSlideShowBtns();
			
			var maxWidth:Number = 0;
			maxWidth = createThumbs();
			
			thumbScroll.setData(maxWidth, scrollWrap.maskWidth);			
			scrollWrap.addChild(thumbScroll);
	
			setInitialScroll(photosXML.layout.@flag);

			//Start the Slideshow
			intervalId = setInterval(slideShowNext, intervalDuration);

		}

		protected function createThumbs() 
		{
			// THUMBNAILS (Layout the photo thumbnails) 
			var maxWidth:Number = 0;
			var i:uint = 0;
			for each(var prop5:XML in photosXML.image )
			{
				var deltaX:Number = i - Math.floor(i / thumbsPerRow) * thumbsPerRow;
				var deltaY:Number = Math.floor(i / thumbsPerRow);
				var data:XML = photosXML.image[i];
				thumbs[i] = new PhotoThumbnail();
				thumbs[i].setData(i, data);
				
				var thumbw:Number = data.@thumbw;
				var thumbh:Number = data.@thumbh;
				thumbs[i].x = deltaX *(thumbw + thumbXSpacing) + thumbXBegin;
				thumbs[i].y = deltaY *(thumbh + thumbYSpacing) + thumbYBegin;
				
				maxWidth = thumbs[i].x + thumbw + thumbXSpacing;
				thumbs[i].addEventListener(MouseEvent.CLICK, thumbClickHandler);

				thumbScroll.addChild(thumbs[i]);
				i++;
			}
		}
		
		protected function displayPicture(thisThumb:*):void
		{	
			var thumbPos = thumbScroll.x + thisThumb.x;
			
			if (thumbPos <= 0)
				thumbScroll.scrollToPos(thumbPos -  thumbXBegin);
			else if (thumbPos > scrollWrap.mask.width)
				thumbScroll.scrollToPos(thumbPos - scrollWrap.mask.width + thisThumb.width);

			photoDetail.visible = true;
			if (selectedItem)
				selectedItem.setFocus(false);
			photoDetail.displayPicture(thisThumb.getData());
			thisThumb.setFocus(true);
			selectedItem = thisThumb;
		}

		protected function createSlideShowBtns():void
		{
			// Create buttons
			nextBtn = new NextBtn;
			nextBtn.y = ySlideShowBtn;
			nextBtn.x = xNextBtn;
			nextBtn.addEventListener(MouseEvent.CLICK, nextClickHandler);
			addChild(nextBtn);

			previousBtn = new PreviousBtn;
			previousBtn.y = ySlideShowBtn;
			previousBtn.x = xPreviousBtn;
			previousBtn.addEventListener(MouseEvent.CLICK, previousClickHandler);
			addChild(previousBtn);
	
			pauseBtn = new PauseBtn;
			pauseBtn.y = ySlideShowBtn;
			pauseBtn.x = xPauseBtn;
			pauseBtn.addEventListener(MouseEvent.CLICK, pauseClickHandler);
			addChild(pauseBtn);	
			pauseBtn.visible = true;

			playBtn = new PlayBtn;
			playBtn.y = ySlideShowBtn;
			playBtn.x = xPlayBtn;
			playBtn.addEventListener(MouseEvent.CLICK, playClickHandler);
			addChild(playBtn);	
			playBtn.visible = false;

			switchLeftBtn = new SwitchLeftBtn;
			switchLeftBtn.y = 0;
			switchLeftBtn.x = 30;
			switchLeftBtn.scaleX = switchLeftBtn.scaleY = 1.5;
			switchLeftBtn.addEventListener(MouseEvent.CLICK, switchLeftClickHandler);
			scrollBase.addChild(switchLeftBtn);	
			
			switchRightBtn = new SwitchRightBtn;
			switchRightBtn.y = 0;
			switchRightBtn.x = thumbScrollX + scrollWrap.maskWidth + 35;
			switchRightBtn.scaleX = switchRightBtn.scaleY = 1.5;
			switchRightBtn.addEventListener(MouseEvent.CLICK, switchRightClickHandler);
			scrollBase.addChild(switchRightBtn);	

			janBThomasBtn = new JanBThomasBtn;
			janBThomasBtn.y = janBThomasY;
			janBThomasBtn.x = janBThomasX;
			janBThomasBtn.addEventListener(MouseEvent.CLICK, janBThomasClickHandler);
			addChild(janBThomasBtn);	
		}		
		
		protected function createScrollBtns():void
		{
			// Create buttons
			scrollNextBtn = new ScrollNextBtn;
			scrollNextBtn.y = 74;
			scrollNextBtn.x = thumbScrollX + scrollWrap.maskWidth + 17;
			scrollNextBtn.addEventListener(MouseEvent.MOUSE_OVER, overScrollNextBtn);
			scrollNextBtn.addEventListener(MouseEvent.MOUSE_OUT, outScrollNextBtn);			
			scrollBase.addChild(scrollNextBtn);

			scrollPreviousBtn = new ScrollPreviousBtn;
			scrollPreviousBtn.y = 75;
			scrollPreviousBtn.x = thumbScrollX - 12;
			scrollPreviousBtn.addEventListener(MouseEvent.MOUSE_OVER, overScrollPreviousBtn);
			scrollPreviousBtn.addEventListener(MouseEvent.MOUSE_OUT, outScrollPreviousBtn);
			scrollBase.addChild(scrollPreviousBtn);
			
		}
		
        private function drawScrollBg():void {

		  var fillType:String = GradientType.LINEAR;
		  var colors:Array = [0xffffff, 0xB5A59B];
		  var alphas:Array = [1, 1];
		  var ratios:Array = [0x00, 0xFF];
		  var matr:Matrix = new Matrix();
		  
		  scrollBg = new Sprite()

		  scrollBg.x = 0;
		  scrollBg.y = 0;
		  scrollBg.graphics.beginFill(0xB5A59B);
		  scrollBg.graphics.drawRect(45,0,707,97);
		  scrollBg.graphics.endFill();
		  
		  matr.createGradientBox(800, 100, 45, 0, 0);
		  var spreadMethod:String = SpreadMethod.PAD;
		  scrollBg.graphics.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod);  
		  scrollBg.graphics.drawRect(47,2,703,93);
		  scrollBg.graphics.endFill();
		  
		  scrollBase.addChild(scrollBg);
        }
		private function scaleScrollBg(toggleLeft:Boolean):void {
			if (toggleLeft) {
				scrollBg.scaleX = .747;
				scrollBg.x = 11;
			}
			else {
				scrollBg.scaleX = 1;
				scrollBg.x = 0;
			}
		}
		private function rotateThumbs(rotationAmt:Number):void 
		{
			var i :uint = 0;
			for( i=0; i < thumbs.length; i++){
				thumbs[i].rotation = rotationAmt;
				thumbs[i].y = (rotationAmt == 0) ? 10 : 82;
			}
		}
		
	}
}
