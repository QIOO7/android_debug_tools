BEGIN{
}
{
    # 苹果公司最新股价的url
	    url = "http://hq.sinajs.cn/list=gb_aapl";
		    # 使用curl命令来获取
			    # 因为源数据是gb2312编码，再使用iconv做一次编码转换
				    cmd = "curl -s " url "|iconv -f gb2312 -t utf-8";
					 
					     # 通过管道执行命令，并将结果保存到result
						     cmd | getline result;
							     # 关闭命令管道
								     close(cmd);
									     # 输出结果
										     print(result);
											 }
											 END{
											 }
