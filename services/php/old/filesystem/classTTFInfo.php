<?php
	class ttf {

		// V 1.1 - unicode characters/null bytes inside fontparameters handling
		// V 1.0 - initial release

		private function dec2hex($dec){
			$hex=dechex($dec);
			return( str_repeat("0",2-strlen($hex)) . strtoupper($hex) );
		}

		public function get_friendly_ttf_name($ttf_filename) {
			$fd = fopen ($ttf_filename, "r");
			$text = fread ($fd, filesize ($ttf_filename));
			fclose ($fd);
			$number_of_tabs = $this->dec2hex(ord($text[4]))
													.$this->dec2hex(ord($text[5]));
			for ($i=0;$i<hexdec($number_of_tabs);$i++){
				$tag = $text[12+$i*16].$text[12+$i*16+1].$text[12+$i*16+2].$text[12+$i*16+3];
				if ($tag == "name") {
					$offset_name_table_hex = $this->dec2hex(ord($text[12+$i*16+8]))
																		.$this->dec2hex(ord($text[12+$i*16+8+1]))
																		.$this->dec2hex(ord($text[12+$i*16+8+2]))
																		.$this->dec2hex(ord($text[12+$i*16+8+3]));
					$offset_name_table_dec = hexdec($offset_name_table_hex);
					$offset_storage_hex = $this->dec2hex(ord($text[$offset_name_table_dec+4]))
																	.$this->dec2hex(ord($text[$offset_name_table_dec+5]));
					$offset_storage_dec = hexdec($offset_storage_hex);
					$number_name_records_hex = $this->dec2hex(ord($text[$offset_name_table_dec+2]))
																			.$this->dec2hex(ord($text[$offset_name_table_dec+3]));
					$number_name_records_dec = hexdec($number_name_records_hex);
					break;
				}
			}
			$storage_dec = $offset_storage_dec + $offset_name_table_dec;
			$storage_hex = strtoupper(dechex($storage_dec));
			for ($j=0;$j<$number_name_records_dec;$j++){
				$platform_id_hex = $this->dec2hex(ord($text[$offset_name_table_dec+6+$j*12+0])).$this->dec2hex(ord($text[$offset_name_table_dec+6+$j*12+1]));
				$platform_id_dec = hexdec($platform_id_hex);
				$name_id_hex = $this->dec2hex(ord($text[$offset_name_table_dec+6+$j*12+6])).$this->dec2hex(ord($text[$offset_name_table_dec+6+$j*12+7]));
				$name_id_dec = hexdec($name_id_hex);
				$string_length_hex = $this->dec2hex(ord($text[$offset_name_table_dec+6+$j*12+8])).$this->dec2hex(ord($text[$offset_name_table_dec+6+$j*12+9]));
				$string_length_dec = hexdec($string_length_hex);
				$string_offset_hex = $this->dec2hex(ord($text[$offset_name_table_dec+6+$j*12+10])).$this->dec2hex(ord($text[$offset_name_table_dec+6+$j*12+11]));
				$string_offset_dec = hexdec($string_offset_hex);
				if ($name_id_dec==0 and !isset($copyright)) {
					$copyright='';
					for($l=0;$l<$string_length_dec;$l++){
						if ($text[$storage_dec+$string_offset_dec+$l]!="\x0"){
							# skip null bytes
							$copyright.=$text[$storage_dec+$string_offset_dec+$l];
						}
					}
				}
				if ($name_id_dec==1 and !isset($fontfamily)) {
					$fontfamily='';
					for($l=0;$l<$string_length_dec;$l++){
						if ($text[$storage_dec+$string_offset_dec+$l]!="\x0"){
							# skip null bytes
							$fontfamily.=$text[$storage_dec+$string_offset_dec+$l];
						}
					}
				}
				if ($name_id_dec==2 and !isset($fontsubfamily)) {
					$fontsubfamily='';
					for($l=0;$l<$string_length_dec;$l++){
						if ($text[$storage_dec+$string_offset_dec+$l]!="\x0"){
							# skip null bytes
							$fontsubfamily.=$text[$storage_dec+$string_offset_dec+$l];
						}
					}
				}
				if ($name_id_dec==4 and !isset($fullfontname)) {
					$fullfontname ='';
					for($l=0;$l<$string_length_dec;$l++){
						if ($text[$storage_dec+$string_offset_dec+$l]!="\x0"){
							# skip null bytes
							$fullfontname.=$text[$storage_dec+$string_offset_dec+$l];
						}
					}
				}
				if (!isset($fontfamily) and !isset($fontsubfamily) and !isset($fullfontname) and !isset($copyright)) {
					break;
				}
			}
			return (array('fontfamily'=>$fontfamily,
											'fontsubfamily'=>$fontsubfamily,
											'fullfontname'=>$fullfontname,
											'copyright'=>$copyright));
		}
	}

?>