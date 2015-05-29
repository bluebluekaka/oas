package com.oas.util;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import net.sf.json.JSON;
import net.sf.json.JSONArray;
import net.sf.json.JSONSerializer;
import net.sf.json.util.JSONUtils;
import net.sf.json.xml.XMLSerializer;



public class JsonUtil {
	private static String top = "{";
	private static String top_ = "}"; 
	@SuppressWarnings("unchecked")
	public static String getJsonByList(List dList){
		String data = "";
		if(dList != null){
			JSONArray ja = JSONArray.fromObject(dList);
			data = ja.toString();
		}
		return data;
	}
	
	/***
	 *  ���ж����ʶjson���
	 *  @param params
	 *  @return
	 */
	@SuppressWarnings("unchecked")
	public static String getObjectJsonData(HashMap params){
		StringBuffer data = new StringBuffer();
		int i = 0;
		if(params != null){
			data.append(top);
			Iterator it = params.entrySet().iterator();
			while(it.hasNext()){
				Entry element = (Entry)it.next(); 
				String key = (String)element.getKey();
				List dList = (ArrayList)element.getValue();
				if(i > 0)data.append(",");
				data.append("\"" + key + "\"" + ":");
				data.append(getJsonByList(dList));	
				i++;
			}
			data.append(top_);
		}
		return data.toString();
	}
	
	/***
	 *  ���ext��json��ʽ���
	 *  @param dList
	 *  @return
	 */
	@SuppressWarnings("unchecked")
	public static String getExtGridJsonData(List dList){
		StringBuffer data = new StringBuffer();
		if(dList != null){
			data.append("{\"totalCount\":" + dList.size() + ", \"Body\":");
            data.append(getJsonByList(dList));
			data.append("}");
		}
		return data.toString();
	}
	
	public static String getGridJsonData(int rowNumber, List dList){
		StringBuffer data = new StringBuffer();
		if(dList != null){
			data.append("{\"totalCount\":" + rowNumber + ", \"Body\":");
            data.append(getJsonByList(dList));
			data.append("}");
		}
		return data.toString();
	}
	
	public static String getLigerUIGridJsonData(int rowNumber, List dList){
		StringBuffer data = new StringBuffer();
		if(dList != null){
			data.append("{\"totalCount\":" + rowNumber + ", \"Body\":");
            data.append(getJsonByList(dList));
			data.append("}");
		}
		return data.toString();
	}
	
	
	public static String getDefineJsonData(String firstParam,String listParam,String firstValue,List dList){
		StringBuffer data = new StringBuffer();
		if(dList != null){
			data.append("{\""+firstParam+"\":" + firstValue + ", \""+ listParam +"\":");
            data.append(getJsonByList(dList));
			data.append("}");
		}
		return data.toString();
	}
	
	/***
	 *  ��json���
	 *  @param dList
	 *  @return
	 */
	public static String getBasetJsonData(List dList){
			StringBuffer data = new StringBuffer();
			if(dList != null){
				JSONArray ja = JSONArray.fromObject(dList);
				data.append(ja.toString());
			}
			return data.toString();
		
	}
	
	/**
	 * EasyUI Json���
	 * @param dList
	 * @return
	 */
	public static String getEasyUIJsonData(List dList){
	    StringBuffer data = new StringBuffer();
	    if(dList != null){
		if(dList.size()>0){
		    String total = StringUtil.toString(((Map)dList.get(0)).get("IRECCOUNT"));
		    data.append("{\"total\": " + total + ", \"rows\": " + getJsonByList(dList) + "}");
		}else{
		    data.append("{\"total\": 0, \"rows\": []}");
		}
	    }
	    return data.toString();
	}
	
	/**
	 * ������ת��json����
	 * @param obj
	 * @return
	 */
	public static String getJsonDataByObject(Object obj){
	    StringBuffer data = new StringBuffer();
	    if(obj != null){
		data.append(JSONArray.fromObject(obj).toString());
	    }
	    return data.toString();
	}
	
	/**
	 * JSON�ַ�ת����XML
	 * @param json
	 * @return
	 */
//	public static String jsonToXml(String json){
//		try{
//			XMLSerializer serializer = new XMLSerializer();
//			JSON jsonObject = JSONSerializer.toJSON(json);
//			return serializer.write(jsonObject);
//		}catch (Exception e) {
//			e.printStackTrace();
//		}
//		return null;
//	}
	
	/**
	 * XMLת��ΪMAP
	 * @param xml
	 * @return
	 */
//	public static Map xmlToMap(String xml){
//		try{
//			Map map = new HashMap();
//			Document document = DocumentHelper.parseText(xml);
//			Element nodeElement = document.getRootElement();
//			List node = nodeElement.elements();
//			for(Iterator it = node.iterator();it.hasNext();){
//				Element elm = (Element)it.next();
//				map.put(elm.getName(), elm.getText());
//				elm = null;
//			}
//			node = null;
//			nodeElement = null;
//			document = null;
//			return map;
//		}catch (Exception e) {
//			e.printStackTrace();
//		}
//		return null;
//	}
	
	/**
	 * ��JSON�ַ�ת���ɶ���
	 * @param str
	 * @return
	 */
//	public static Map<String,String> jsonToMap(String str){
//		String xml = jsonToXml(str);
//		return xmlToMap(xml);
//	}
	
	//-------------------edit by XiaoHuifeng,2012-8-8
	/**
	 * ��JSON�ַ�ת���ɶ��󣨶���ֵΪ����������������ƴ���ö��ŷָ����ַ��أ�
	 * @param str
	 * @return
	 */
//	public static Map<String,String> jsonToMapWithArray(String str){
//		String xml = jsonToXml(str);
//		return xmlToMapWithArray(xml);
//	}
	
	/**
	 * XMLת����Map������ֵΪ����������������ƴ���ö��ŷָ����ַ��أ�
	 * @param xml
	 * @return
	 */
//	public static Map xmlToMapWithArray(String xml){
//		try{
//			Map map = new HashMap();
//			Document document = DocumentHelper.parseText(xml);
//			Element nodeElement = document.getRootElement();
//			List node = nodeElement.elements();
//			for(Iterator it = node.iterator();it.hasNext();){
//				Element elm = (Element)it.next();
//				
//				if(elm.elements().size() > 0){
//					String valueForJson = "";
//					List arr = new ArrayList();
//					for(Iterator it2 = elm.elements().iterator(); it2.hasNext();){
//						Element elmForArr = (Element)it2.next();
//						arr.add(elmForArr.getText());
//					}
//					valueForJson = JsonUtil.getJsonByList(arr);
//					map.put(elm.getName(), valueForJson);
//				}else{
//					map.put(elm.getName(), elm.getText());
//				}
//				elm = null;
//			}
//			node = null;
//			nodeElement = null;
//			document = null;
//			return map;
//		}catch (Exception e) {
//			e.printStackTrace();
//		}
//		return null;
//	}
}