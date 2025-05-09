import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'wallet_state.dart';

enum TimeFrame { oneDay, fiveDays, oneMonth, sixMonths, oneYear, fiveYears }

class DataPoint {
  DataPoint({required this.date, required this.price});
  final DateTime date;
  final double price;
}

class WalletController extends ChangeNotifier {
  WalletState _state = WalletStateInitial();
  WalletState get state => _state;
  
  // Valores atuais
  double stockPrice = 0.0;
  double stockChange = 0.0; // Em porcentagem
  
  double bitcoinPrice = 0.0;
  double bitcoinChange = 0.0; // Em porcentagem
  
  // Dados históricos completos (exemplo simulado)
  List<DataPoint> allStockData = [];
  List<DataPoint> allBitcoinData = [];
  
  // Dados filtrados para o gráfico
  List<double> stockGraphData = [];
  List<double> bitcoinGraphData = [];
  
  // Período selecionado (padrão: 1 dia)
  TimeFrame selectedTimeFrame = TimeFrame.oneDay;
  
  // Chave de API para Alpha Vantage (substitua pela sua)
  final String alphaVantageApiKey = 'IGUI0B88EYLF3QKP';
  
  WalletController() {
    fetchWalletData();
  }
  
  Future<void> fetchWalletData() async {
    _state = WalletStateLoading();
    notifyListeners();
    
    try {
      // Buscando dados reais do Bitcoin e da ação
      await fetchBitcoinData();
      await fetchNvidiaData();
      
      // Suponha que os dados históricos sejam preenchidos (aqui simulamos)
      DateTime now = DateTime.now();
      // Simula 5 anos de dados diários para ações e bitcoin
      allStockData = List.generate(5 * 365, (index) {
        DateTime date = now.subtract(Duration(days: index));
        // Simulação: flutuação em torno do preço atual
        return DataPoint(date: date, price: stockPrice - index * 0.1);
      }).reversed.toList();
      
      allBitcoinData = List.generate(5 * 365, (index) {
        DateTime date = now.subtract(Duration(days: index));
        return DataPoint(date: date, price: bitcoinPrice - index * 10);
      }).reversed.toList();
      
      // Atualiza os dados do gráfico com base no intervalo selecionado
      filterGraphData();
      
      _state = WalletStateSuccess();
    } catch (e) {
      _state = WalletStateError(message: e.toString());
    }
    
    notifyListeners();
  }
  
  Future<void> fetchBitcoinData() async {
    final url = Uri.parse(
      'https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=usd&include_24hr_change=true'
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      bitcoinPrice = (data['bitcoin']['usd'] as num).toDouble();
      bitcoinChange = (data['bitcoin']['usd_24h_change'] as num).toDouble();
    } else {
      throw Exception('Falha ao carregar os dados do Bitcoin');
    }
  }
  
  Future<void> fetchNvidiaData() async {
    final url = Uri.parse(
      'https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=NVDA&apikey=$alphaVantageApiKey'
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final quote = data['Global Quote'];
      if (quote == null || quote.isEmpty) {
        throw Exception('Dados inválidos para NVDA');
      }
      stockPrice = double.parse(quote['05. price']);
      // Exemplo de variação (pode ser ajustado conforme o retorno da API)
      String changePercentStr = quote['10. change percent'];
      changePercentStr = changePercentStr.replaceAll('%', '');
      stockChange = double.parse(changePercentStr);
    } else {
      throw Exception('Falha ao carregar os dados da Nvidia');
    }
  }
  
  // Método para atualizar o período selecionado e filtrar os dados
  void updateTimeFrame(TimeFrame timeFrame) {
    selectedTimeFrame = timeFrame;
    filterGraphData();
    notifyListeners();
  }
  
  // Filtra os dados históricos com base no período selecionado
  void filterGraphData() {
    DateTime now = DateTime.now();
    DateTime startDate;
    switch(selectedTimeFrame) {
      case TimeFrame.oneDay:
        startDate = now.subtract(const Duration(days: 1));
        break;
      case TimeFrame.fiveDays:
        startDate = now.subtract(const Duration(days: 5));
        break;
      case TimeFrame.oneMonth:
        startDate = DateTime(now.year, now.month - 1, now.day);
        break;
      case TimeFrame.sixMonths:
        startDate = DateTime(now.year, now.month - 6, now.day);
        break;
      case TimeFrame.oneYear:
        startDate = DateTime(now.year - 1, now.month, now.day);
        break;
      case TimeFrame.fiveYears:
        startDate = DateTime(now.year - 5, now.month, now.day);
        break;
    }
    
    stockGraphData = allStockData
        .where((data) => data.date.isAfter(startDate))
        .map((data) => data.price)
        .toList();
    
    bitcoinGraphData = allBitcoinData
        .where((data) => data.date.isAfter(startDate))
        .map((data) => data.price)
        .toList();
  }
}
