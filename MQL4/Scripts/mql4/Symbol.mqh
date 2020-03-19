// 市场的相关操作函数
class Symbol{
	public:
	/**@description 总的市场数量 true: all selected number else false: all symbol number */
	static int Total(bool selected);
	/**@description 市场的名称 */
	static string Name(int pos, bool select);
};

static int Symbol::Total(bool selected){
	return SymbolsTotal(selected);
}

static string Symbol::Name(int pos, bool select){
	return SymbolName(pos, select);
}