package org.josht.starling.foxhole.displayObjects.screens
{
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import org.josht.starling.display.Image;
	import org.josht.starling.display.Scale3Image;
	import org.josht.starling.display.Scale3Image;
	import org.josht.starling.foxhole.controls.Screen;
	import org.josht.starling.foxhole.controls.Button;
	import org.josht.starling.foxhole.controls.ScreenHeader;
	import org.osflash.signals.Signal;

	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	import starling.textures.Texture;

	public class Scale3ImageScreen extends Screen
	{
		[Embed(source="/../assets/images/scale3.png")]
		private static const SCALE_3_TEXTURE:Class;

		[Embed(source="/../assets/images/horizontal-grip.png")]
		private static const HORIZONTAL_GRIP:Class;

		[Embed(source="/../assets/images/vertical-grip.png")]
		private static const VERTICAL_GRIP:Class;

		public function Scale3ImageScreen()
		{
		}

		private var _header:ScreenHeader;
		private var _image:Scale3Image;
		private var _rightButton:Button;
		private var _bottomButton:Button;

		private var _minDisplayObjectWidth:Number;
		private var _minDisplayObjectHeight:Number;
		private var _maxDisplayObjectWidth:Number;
		private var _maxDisplayObjectHeight:Number;
		private var _startX:Number;
		private var _startY:Number;
		private var _startWidth:Number;
		private var _startHeight:Number;
		private var _rightTouchPointID:int = -1;
		private var _bottomTouchPointID:int = -1;

		override protected function initialize():void
		{
			this._header = new ScreenHeader();
			this._header.title = "Scale 3 Image";
			this.addChild(this._header);

			this._image = new Scale3Image(Texture.fromBitmap(new SCALE_3_TEXTURE(), false), 30, 40, Scale3Image.DIRECTION_HORIZONTAL, this.dpiScale);
			this._minDisplayObjectWidth = this._image.width;
			this._minDisplayObjectHeight = this._image.height;
			this.addChild(this._image);

			this._rightButton = new Button();
			this._rightButton.addEventListener(TouchEvent.TOUCH, rightButton_touchHandler);
			this.addChild(this._rightButton);
			const rightSkin:Image = new Image(Texture.fromBitmap(new VERTICAL_GRIP(), false));
			rightSkin.scaleX = rightSkin.scaleY = this.dpiScale;
			this._rightButton.defaultSkin = rightSkin;
			this._rightButton.upSkin = this._rightButton.downSkin = null;

			this._bottomButton = new Button();
			this._bottomButton.addEventListener(TouchEvent.TOUCH, bottomButton_touchHandler);
			this.addChild(this._bottomButton);
			const bottomSkin:Image = new Image(Texture.fromBitmap(new HORIZONTAL_GRIP(), false));
			bottomSkin.scaleX = bottomSkin.scaleY = this.dpiScale;
			this._bottomButton.defaultSkin = bottomSkin;
			this._bottomButton.upSkin = this._bottomButton.downSkin = null;
		}

		override protected function draw():void
		{
			this._header.width = this.actualWidth;
			this._header.validate();

			this._image.x = 30 * this.dpiScale;
			this._image.y = this._header.height + 30 * this.dpiScale;

			this._rightButton.validate();
			this._bottomButton.validate();

			this._maxDisplayObjectWidth = this.actualWidth - this._rightButton.width - this._image.x;
			this._maxDisplayObjectHeight = this.actualHeight - this._bottomButton.height - this._image.y - this._header.height;

			this._image.width = Math.max(this._minDisplayObjectWidth, Math.min(this._maxDisplayObjectWidth, this._image.width));
			this._image.height = Math.max(this._minDisplayObjectHeight, Math.min(this._maxDisplayObjectHeight, this._image.height));

			this.layoutButtons();
		}

		private function layoutButtons():void
		{
			this._rightButton.x = this._image.x + this._image.width;
			this._rightButton.y = this._image.y + (this._image.height - this._rightButton.height) / 2;

			this._bottomButton.x = this._image.x + (this._image.width - this._bottomButton.width) / 2;
			this._bottomButton.y = this._image.y + this._image.height;
		}

		private function rightButton_touchHandler(event:TouchEvent):void
		{
			const touch:Touch = event.getTouch(this._rightButton);
			if(!touch || (this._rightTouchPointID >= 0 && touch.id != this._rightTouchPointID))
			{
				return;
			}

			if(touch.phase == TouchPhase.BEGAN)
			{
				this._rightTouchPointID = touch.id;
				this._startX = touch.globalX;
				this._startWidth = this._image.width;
			}
			else if(touch.phase == TouchPhase.MOVED)
			{
				this._image.width = Math.min(this._maxDisplayObjectWidth, Math.max(this._image.height, this._minDisplayObjectWidth, this._startWidth + touch.globalX - this._startX));
				this.layoutButtons()
			}
			else if(touch.phase == TouchPhase.ENDED)
			{
				this._rightTouchPointID = -1;
			}
		}

		private function bottomButton_touchHandler(event:TouchEvent):void
		{
			const touch:Touch = event.getTouch(this._bottomButton);
			if(!touch || (this._bottomTouchPointID >= 0 && touch.id != this._bottomTouchPointID))
			{
				return;
			}

			if(touch.phase == TouchPhase.BEGAN)
			{
				this._bottomTouchPointID = touch.id;
				this._startY = touch.globalY;
				this._startHeight = this._image.height;
			}
			else if(touch.phase == TouchPhase.MOVED)
			{
				this._image.height = Math.min(this._image.width,  this._maxDisplayObjectHeight, Math.max(this._minDisplayObjectHeight, this._startHeight + touch.globalY - this._startY));
				this.layoutButtons()
			}
			else if(touch.phase == TouchPhase.ENDED)
			{
				this._bottomTouchPointID = -1;
			}
		}
	}
}
