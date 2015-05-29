package com.test.kaoshi;

import java.util.Random;
import java.util.Set;

public class BubbleSort {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		BubbleSort bs= new BubbleSort();
		Random rd = new Random();
		int[] bsList= new int[10];
		for(int ii=0; ii<bsList.length ;ii++){
			int j=Math.abs(rd.nextInt(100)) ;
			bsList[ii]=j;
			System.out.print(bsList[ii]+" ");
		}
		int[]tmpList= bsList;
		System.out.println();
	    System.out.println("====================================");

		long startTime=System.nanoTime();   //获取开始时间
		
		bs.bubbleSort(bsList);
		
	     long endTime=System.nanoTime(); //获取结束时间
	     System.out.println();
	    System.out.println("冒泡排序：程序运行时间： "+(endTime-startTime)+"ns");
	    System.out.println("====================================");
		long startTime1=System.nanoTime();   //获取开始时间
		
		bs.doChooseSort(tmpList);
		
	     long endTime1=System.nanoTime(); //获取结束时间
	     System.out.println();
	    System.out.println("选择排序：程序运行时间： "+(endTime1-startTime1)+"ns");
	    System.out.println("====================================");
		long startTime2=System.nanoTime();   //获取开始时间
		
		bs.insertSort(tmpList);
		
	     long endTime2=System.nanoTime(); //获取结束时间
	     System.out.println();
	    System.out.println("插入排序：程序运行时间： "+(endTime2-startTime2)+"ns");
	}
	/**
     *冒泡排序
     *@paramsrc待排序数组
     */
	public int[] bubbleSort( int[] ss){
		for( int i=0;i<ss.length;i++){
			for( int j=i+1 ;j<ss.length ;j++){
				int tmp;
				if(ss[i]>ss[j]){
					tmp=ss[i];
					ss[i]=ss[j];
					ss[j]=tmp;
				}
			}
			System.out.print( ss[i]+" ");
		}
		return ss;
	}
    /**
     *选择排序
     *@paramsrc待排序的数组
     */
    void doChooseSort(int[] src)
    {
       int len=src.length;
       int temp;
       for(int i=0;i<len;i++)
       {
           temp=src[i];
           int j;
           int samllestLocation=i;//最小数的下标
           for(j=i+1;j<len;j++)
           {
              if(src[j]<temp)
              {
                  temp=src[j];//取出最小值
                  samllestLocation=j;//取出最小值所在下标
              }
           }
           src[samllestLocation]=src[i];
           src[i]=temp;
           System.out.print( src[i]+" ");
       }
    }
/*    插入排序
*/   
    public static void insertSort(int src[]) {
    	int len = src.length;
    	for (int i = 1; i < len; i++) {
    	int temp = src[i];// 待插入的值
    	int index = i;// 待插入的位置
    	while (index > 0 && src[index - 1] > temp) {
    		src[index] = src[index - 1];// 待插入的位置重新赋更大的值
    	index--;// 位置往前移
    	}
    	src[index] = temp;
    	 System.out.print( src[i]+" ");
    	}
    	}
}
