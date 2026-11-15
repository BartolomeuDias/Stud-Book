{{flutter_js}}
{{flutter_build_config}}

const hideSplash = () => {
  const splash = document.getElementById('splash');
  if (!splash) return;
  splash.classList.add('hidden');
  splash.addEventListener('transitionend', () => splash.remove(), { once: true });
};

const splashFallbackMs = 8000;

window.addEventListener('flutter-first-frame', hideSplash, { once: true });
setTimeout(hideSplash, splashFallbackMs);

_flutter.loader.load({
  onEntrypointLoaded: async (engineInitializer) => {
    const appRunner = await engineInitializer.initializeEngine();
    await appRunner.runApp();
  },
});
