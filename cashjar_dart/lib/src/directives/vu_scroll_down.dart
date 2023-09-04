import 'dart:html';
import 'dart:async';
import 'package:angular/angular.dart';

@Directive(selector: "[vuScrollDown]")
class VuScrollDown {
  Element _el;

  MutationObserver _mo;

  Map<StreamSubscription, bool> loadSubs = {};

  VuScrollDown(this._el) {
    _mo = MutationObserver(_mutation);
    _mo.observe(_el, childList: true, subtree: true);
  }

  void _mutation(List<dynamic> mutations, MutationObserver observer) {
    for (dynamic mutation in mutations) {
      for (Node node in (mutation as MutationRecord).addedNodes) {
        if (node is Element) {
          ElementList images = node.querySelectorAll("img");

          for (ImageElement img in images) {
            StreamSubscription loadSub;
            loadSub = img.onLoad.listen((_) {
              _scrollToBottom();

              if (loadSubs.containsKey(loadSub)) {
                loadSub.cancel();
                loadSubs.remove(loadSub);
              }
            });

            loadSubs[loadSub] = true;
          }
        }
      }
    }

    _scrollToBottom();
  }

  void _scrollToBottom() {
    _el.scrollTop = _el.scrollHeight;
  }
}