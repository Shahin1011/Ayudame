import 'package:get/get.dart';
import '../models/card_model.dart';

class UserCardController extends GetxController {
  Rxn<CardModel> defaultCard = Rxn<CardModel>();

  void saveCard(CardModel card) {
    defaultCard.value = card;
  }

  void removeCard() {
    defaultCard.value = null;
  }
}
