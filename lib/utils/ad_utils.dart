import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Utility class for managing Google Mobile Ads (Interstitial, Rewarded, Banner)
class AdUtils {
  static InterstitialAd? _interstitialAd;
  static RewardedAd? _rewardedAd;

  /// Loads an Interstitial Ad using a test ad unit ID.
  static void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/1033173712', // Test Ad Unit ID
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          debugPrint('Interstitial ad loaded.');
        },
        onAdFailedToLoad: (LoadAdError error) {
          _interstitialAd = null;
          debugPrint('Failed to load interstitial ad: $error');
        },
      ),
    );
  }

  /// Displays the Interstitial Ad if it's available.
  static void showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          ad.dispose();
          loadInterstitialAd(); // Reload for next time
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          debugPrint('Failed to show interstitial ad: $error');
          loadInterstitialAd();
        },
      );
      _interstitialAd!.show();
      _interstitialAd = null;
    } else {
      debugPrint('Interstitial ad is not loaded yet.');
    }
  }

  /// Loads a Rewarded Ad using a test ad unit ID.
  static void loadRewardedAd() {
    RewardedAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/5224354917', // Test Ad Unit ID
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          _rewardedAd = ad;
          debugPrint('Rewarded ad loaded.');
        },
        onAdFailedToLoad: (LoadAdError error) {
          _rewardedAd = null;
          debugPrint('Failed to load rewarded ad: $error');
        },
      ),
    );
  }

  /// Shows the Rewarded Ad if it's available.
  static void showRewardedAd({
    required void Function(RewardItem reward) onUserEarnedReward,
  }) {
    if (_rewardedAd != null) {
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (RewardedAd ad) {
          ad.dispose();
          loadRewardedAd(); // Reload for next time
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          debugPrint('Failed to show rewarded ad: $error');
          loadRewardedAd();
        },
      );
      _rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          debugPrint("User earned reward: ${reward.amount} ${reward.type}");
          onUserEarnedReward(reward);
        },
      );
      _rewardedAd = null;
    } else {
      debugPrint('Rewarded ad is not loaded yet.');
    }
  }
}

/// Widget to display a banner ad
class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  late BannerAd _bannerAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  /// Loads a Banner Ad
  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111', // Test Ad Unit ID
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          setState(() => _isAdLoaded = true);
          debugPrint('Banner ad loaded.');
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          debugPrint('Failed to load banner ad: $error');
        },
      ),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    return _isAdLoaded
        ? SizedBox(
          width: _bannerAd.size.width.toDouble(),
          height: _bannerAd.size.height.toDouble(),
          child: AdWidget(ad: _bannerAd),
        )
        : const SizedBox.shrink(); // Return empty widget if not loaded
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }
}
