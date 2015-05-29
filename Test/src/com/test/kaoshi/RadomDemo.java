package com.test.kaoshi;

import java.util.HashSet;
import java.util.Iterator;
import java.util.Random;
import java.util.Set;
import java.util.TreeMap;
import java.util.TreeSet;

/*随机产生20个字符并且排序*/
public class RadomDemo {
	
	
	
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		RadomDemo rd= new RadomDemo();
		Set numSet= rd.getNum();
		for(Iterator it= numSet.iterator();it.hasNext();){
			System.out.print(it.next()+" ");
		}
		System.out.println(); 
		Set numTree = new TreeSet();
		numTree.addAll(numSet);
		for(Iterator ii= numTree.iterator();ii.hasNext();){
			System.out.print(ii.next()+" ");
		}

	}
	public Set getNum(){
		
		Random rd = new Random();
		Set numSet= new HashSet();
		while(numSet.size()<=20){
			int tmpNum=Math.abs(rd.nextInt())%26+99;
			numSet.add(tmpNum);
		}
		return numSet;
		
	}

}
