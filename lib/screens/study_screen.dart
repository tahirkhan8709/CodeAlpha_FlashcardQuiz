// ignore_for_file: deprecated_member_use

import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../data/flashcard_store.dart';
import '../widgets/card_form_dialog.dart';
import 'manage_screen.dart';

class StudyScreen extends StatefulWidget {
  const StudyScreen({super.key, required this.store});

  final FlashcardStore store;

  @override
  State<StudyScreen> createState() => _StudyScreenState();
}

class _StudyScreenState extends State<StudyScreen> {
  int _index = 0;
  bool _showAnswer = false;

  void _move(int delta) {
    setState(() {
      _index += delta;
      _showAnswer = false;
    });
  }

  void _toggleAnswer() => setState(() => _showAnswer = !_showAnswer);

  Future<void> _addCard() async {
    final result = await showCardForm(context);
    if (result == null) return;
    await widget.store.add(result[0], result[1]);
    if (!mounted) return;
    setState(() {
      _index = widget.store.cards.length - 1; // jump to the new card
      _showAnswer = false;
    });
  }

  void _openManage() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ManageScreen(store: widget.store)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.school_rounded,
                size: 20,
                color: colors.primary,
              ),
            ),
            const SizedBox(width: 10),
            const Text('Flashcards'),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Add card',
            icon: const Icon(Icons.add_rounded),
            onPressed: _addCard,
          ),
          IconButton(
            tooltip: 'Manage deck',
            icon: const Icon(Icons.style_rounded),
            onPressed: _openManage,
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: ListenableBuilder(
        listenable: widget.store,
        builder: (context, _) {
          final cards = widget.store.cards;

          if (cards.isEmpty) {
            return _EmptyState(onAdd: _addCard);
          }

          // Keep the index valid if cards were deleted.
          if (_index >= cards.length) _index = cards.length - 1;
          final card = cards[_index];
          final progress = (_index + 1) / cards.length;

          return SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 580),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                  child: Column(
                    children: [
                      // Progress Bar & Header
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: colors.surfaceContainerHighest
                              .withValues(alpha: 0.45),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.layers_outlined,
                                      size: 16,
                                      color: colors.primary,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Card ${_index + 1} of ${cards.length}',
                                      style: theme.textTheme.titleSmall
                                          ?.copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colors.primaryContainer,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '${(progress * 100).round()}%',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: colors.onPrimaryContainer,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value: progress,
                                minHeight: 7,
                                backgroundColor: colors.surfaceContainerHighest,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  colors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 3D Flip Flashcard
                      Expanded(
                        child: GestureDetector(
                          onTap: _toggleAnswer,
                          child: TweenAnimationBuilder<double>(
                            key: ValueKey('${card.id}-anim'),
                            tween: Tween<double>(
                              begin: 0,
                              end: _showAnswer ? 1.0 : 0.0,
                            ),
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOutCubic,
                            builder: (context, value, _) {
                              final isFront = value < 0.5;
                              final angle = value * math.pi;

                              return Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.identity()
                                  ..setEntry(3, 2, 0.001)
                                  ..rotateY(angle),
                                child: isFront
                                    ? _CardFace(
                                        key: const ValueKey('front'),
                                        label: 'QUESTION',
                                        text: card.question,
                                        isAnswer: false,
                                      )
                                    : Transform(
                                        alignment: Alignment.center,
                                        transform: Matrix4.identity()
                                          ..rotateY(math.pi),
                                        child: _CardFace(
                                          key: const ValueKey('back'),
                                          label: 'ANSWER',
                                          text: card.answer,
                                          isAnswer: true,
                                        ),
                                      ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Show / Hide Answer Action Button
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: _toggleAnswer,
                          icon: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: Icon(
                              _showAnswer
                                  ? Icons.visibility_off_rounded
                                  : Icons.visibility_rounded,
                              key: ValueKey(_showAnswer),
                            ),
                          ),
                          label: Text(
                            _showAnswer ? 'Hide Answer' : 'Show Answer',
                          ),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: _showAnswer
                                ? colors.secondary
                                : colors.primary,
                            foregroundColor: _showAnswer
                                ? colors.onSecondary
                                : colors.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Previous & Next Navigation Buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _index > 0 ? () => _move(-1) : null,
                              icon: const Icon(Icons.arrow_back_rounded),
                              label: const Text('Previous'),
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _index < cards.length - 1
                                  ? () => _move(1)
                                  : null,
                              icon: const Icon(Icons.arrow_forward_rounded),
                              label: const Text('Next'),
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CardFace extends StatelessWidget {
  const _CardFace({
    super.key,
    required this.label,
    required this.text,
    required this.isAnswer,
  });

  final String label;
  final String text;
  final bool isAnswer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // Harmonious distinct gradients & colors
    final List<Color> gradientColors = isAnswer
        ? (isDark
            ? [const Color(0xFF132A38), const Color(0xFF0F1E29)]
            : [
                colors.secondaryContainer.withValues(alpha: 0.6),
                colors.surfaceContainerLowest,
              ])
        : (isDark
            ? [const Color(0xFF1E2342), const Color(0xFF141829)]
            : [
                colors.primaryContainer.withValues(alpha: 0.5),
                colors.surfaceContainerLowest,
              ]);

    final badgeColor = isAnswer ? colors.secondary : colors.primary;
    final badgeTextColor = isAnswer
        ? (isDark ? colors.secondaryContainer : colors.secondary)
        : (isDark ? colors.primaryContainer : colors.primary);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: isAnswer
              ? colors.secondary.withValues(alpha: isDark ? 0.35 : 0.25)
              : colors.primary.withValues(alpha: isDark ? 0.35 : 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : colors.primary)
                .withValues(alpha: isDark ? 0.4 : 0.08),
            blurRadius: 24,
            offset: const Offset(0, 10),
            spreadRadius: -2,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
          child: Column(
            children: [
              // Header Badge & Flip indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: badgeColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isAnswer
                              ? Icons.verified_outlined
                              : Icons.quiz_outlined,
                          size: 15,
                          color: badgeTextColor,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          label,
                          style: TextStyle(
                            fontSize: 11,
                            letterSpacing: 1.8,
                            fontWeight: FontWeight.w800,
                            color: badgeTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: colors.onSurface.withValues(alpha: 0.05),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.flip_rounded,
                      size: 16,
                      color: colors.onSurfaceVariant.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),

              // Scrollable Text Content
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: colors.onSurface,
                        fontWeight: FontWeight.w600,
                        height: 1.45,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                ),
              ),

              // Interactive Tap Hint Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.touch_app_outlined,
                    size: 14,
                    color: colors.onSurfaceVariant.withValues(alpha: 0.6),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isAnswer
                        ? 'Tap card to view question'
                        : 'Tap card to reveal answer',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant.withValues(alpha: 0.65),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: colors.primaryContainer.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.style_outlined,
                size: 52,
                color: colors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No flashcards yet',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 320),
              child: Text(
                'Create your first flashcard to start practicing and quizzing yourself.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 28),
            FilledButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add Flashcard'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
