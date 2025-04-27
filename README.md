# paciente_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


# rama principal
git branch
flutter build web --base-href="/prototipe_paciente_app/"
Remove-Item docs -Recurse -Force
xcopy .\build\web .\docs /E /H /C /I
git add docs
git commit -m "modify plans"
git push origin main
https://kevinmoh2o.github.io/prototipe_paciente_app/