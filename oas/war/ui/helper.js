	var htmlDecode = function(str) {
		return str.replace(/&#(x)?([^&]{1,5});?/g,function($,$1,$2) {
			return String.fromCharCode(parseInt($2 , $1 ? 16:10));
		});
	};
	
	function getDatasValue(datas){
		var heads = "";
		var contents = "";
		var hiding = -1;
		try{
		for(var i=0;i<datas.Rows.length;i++){
			var obj = datas.Rows[i];	
			for(var k in obj){
				if(k.indexOf("_")!=-1) break;
				if(i==0){
					if(htmlDecode(k)=='HideID'){
						hiding = k;
						continue;
					}
					heads+=htmlDecode(k)+",";
				}
				if(hiding==k) continue; 
				contents+=htmlDecode(obj[k])+",";
			}
			contents+="\n";	
		}}catch(e){alert(e);}
		return heads + "\n"  + contents + "\n" + htmlDecode(datas.totalRender);
		 
	}
 	
 	function getReplace(str,ochar,nchar){  
		while(str.indexOf(ochar)!=-1)//寻找每一个中文逗号，并替换
		{
			str=str.replace(ochar,nchar);
			 
		}
		return str;
 	}