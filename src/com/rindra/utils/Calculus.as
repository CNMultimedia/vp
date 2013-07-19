package com.rindra.utils{
	public class Calculus{
		public function Calculus(){
			
		}
		internal function convertToMinSec(s:Number):String{
			if(Math.floor(s/60) == 0){
				if(Math.floor(s)%60<10){
					return('00:0'+String(Math.floor(s)%60));
				}else{
					return('00:'+String(Math.floor(s)%60));
				}
			}else{
				if(Math.floor(s/60)<10){
					if(Math.floor(s)%60<10){
						return('0'+String(Math.floor(s/60))+':0'+String(Math.floor(s)%60));
					}else{
						return('0'+String(Math.floor(s/60))+':'+String(Math.floor(s)%60));
					}
				}else{
					if(Math.floor(s)%60<10){
						return(String(Math.floor(s/60))+':0'+String(Math.floor(s)%60));
					}else{
						return(String(Math.floor(s/60))+':'+String(Math.floor(s)%60));
					}
				}
			}
		}
	}
}