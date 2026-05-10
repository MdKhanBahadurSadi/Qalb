import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/nasiha_provider.dart';
import 'dart:ui';

class NasihaScreen extends ConsumerStatefulWidget {
  const NasihaScreen({super.key});

  @override
  ConsumerState<NasihaScreen> createState() => _NasihaScreenState();
}

class _NasihaScreenState extends ConsumerState<NasihaScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(nasihaChatProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final backgroundColor = isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'আন-নাসিহা',
              style: GoogleFonts.hindSiliguri(
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
            Text(
              'আপনার ইসলামিক ওয়েলনেস গাইড',
              style: GoogleFonts.hindSiliguri(
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [const Color(0xFF00332B), const Color(0xFF001A15)]
                  : [const Color(0xFF00796B), const Color(0xFF004D40)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: messages.isEmpty
                ? _buildEmptyState(theme, isDark)
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return _buildChatBubble(theme, message, isDark);
                    },
                  ),
          ),
          _buildInputArea(theme, isDark),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF004D40).withValues(alpha: 0.2) : const Color(0xFFE0F2F1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.auto_awesome_rounded,
                size: 64,
                color: isDark ? const Color(0xFF80CBC4) : const Color(0xFF00695C),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'আসসালামু আলাইকুম!',
              style: GoogleFonts.hindSiliguri(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'আমি আন-নাসিহা। আপনার হার্ট এবং মানসিক প্রশান্তির জন্য ইসলামিক ওয়েলনেস পরামর্শ দিতে আমি প্রস্তুত।',
              textAlign: TextAlign.center,
              style: GoogleFonts.hindSiliguri(
                fontSize: 16,
                color: isDark ? Colors.white70 : const Color(0xFF666666),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatBubble(ThemeData theme, ChatMessage message, bool isDark) {
    final isUser = message.isUser;
    
    // Gradients for premium feel
    final userGradient = LinearGradient(
      colors: isDark
          ? [const Color(0xFF00695C), const Color(0xFF004D40)]
          : [const Color(0xFF00897B), const Color(0xFF00695C)],
    );
    
    final aiGradient = LinearGradient(
      colors: isDark
          ? [const Color(0xFF1E1E1E), const Color(0xFF2C2C2C)]
          : [Colors.white, const Color(0xFFF5F5F5)],
    );

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        decoration: BoxDecoration(
          gradient: isUser ? userGradient : aiGradient,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(24),
            topRight: const Radius.circular(24),
            bottomLeft: Radius.circular(isUser ? 24 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 24),
          ),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black26 : Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
            if (!isDark && !isUser)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 0,
                spreadRadius: 1,
              ),
          ],
        ),
        child: Text(
          message.text,
          style: GoogleFonts.hindSiliguri(
            color: isUser 
                ? Colors.white 
                : (isDark ? Colors.white.withValues(alpha: 0.9) : const Color(0xFF222222)),
            fontSize: 16,
            height: 1.4,
          ),
        ),
      ),
    );
  }

  Widget _buildInputArea(ThemeData theme, bool isDark) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              style: GoogleFonts.hindSiliguri(
                color: isDark ? Colors.white : Colors.black87,
              ),
              decoration: InputDecoration(
                hintText: 'আপনার প্রশ্ন লিখুন...',
                hintStyle: GoogleFonts.hindSiliguri(
                  color: isDark ? Colors.white54 : Colors.black45,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF0F2F5),
                contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF00695C), const Color(0xFF004D40)]
                    : [const Color(0xFF00897B), const Color(0xFF00695C)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00695C).withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: IconButton(
              onPressed: () async {
                final text = _controller.text.trim();
                if (text.isNotEmpty) {
                  _controller.clear();
                  await ref.read(nasihaChatProvider.notifier).sendMessage(text);
                  _scrollToBottom();
                }
              },
              icon: const Icon(Icons.send_rounded, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
