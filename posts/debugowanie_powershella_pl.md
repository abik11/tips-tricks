# Debugowanie Powershell'a

Temat może wydawać się prosty, debugowanie skrytpów nie powinno być raczej niczym trudnym. Wystarczy w kluczowych miejscach naszego skryptu wrzucić komendę `echo` albo `write-host` i wyświetlić w konsoli to co nas interesuje. Fakt, w taki sposób można osiągnąc zamierzony cel i zbadać jak nasz skrypt działa, ale Powershell daje nam dużo wygodniejsze narzędzia do debugowania. Zapoznajmy się z nimi.

Głównym narzędziem z jakiego będziemy korzystać jest komenda `Set-PSBreakpoint`. Pozwala ona zdefiniować breakpoint, który zatrzyma wykonanie skryptu na podstawie wybranego przez nas jednego z trzech warunków, do wyboru mamy:
* wywołanie wybranej komendy
* dostęp do zmiennej (odczyt, zapis, albo odczyt i zapis)
* wykonanie danej lini

Weźmy jako przykład poniższą funkcję, której zadaniem jest wyczyszczenie folderu z projektem Visual Studio poprzez usunięcie folderów `packages`, `.vs`, `bin` oraz `obj`:
```powershell
function Clear-VSSolution {
    [cmdletbinding()]
    Param (
        [string] $solutionDirectory
    )

    $currentDir = Get-Location
    Set-Location $solutionDirectory
    Remove-Item packages, .vs -Force -Recurse
    Get-ChildItem bin, obj -Recurse |
	Remove-Item -Force -Recurse
    Set-Location $currentDir
}
```
Zdefiniujmy sobie parę breakpointów:
```powershell
Set-PSBreakpoint -Command Remove-Item		 #1
Set-PSBreakpoint -Variable currentDir -Mode Read #2
```
Teraz jeśli wywołamy naszą funkcję, zostanie zatrzymana. Poznamy to chociażby po tym, że przed znakiem zachęty pojawi się dodatkowy ciąg znaków: `[DBG]:`. W tym momencie uzyskujemy dostęp do dodatkowych komend, które kontrolują proces debugowania. Komenda `h` wyświetli nam wszystkie te dodatkowe komendy wraz z krótkim opisem. Jeśli kiedykolwiek mieliśmy styczność z debuggerem w innych językach programowania to z łatwością powinniśmy zrozumieć jak działa każda z komend. Wśród najbardziej przydatnych pośród nich można wymienić:
* `v`, `stepOver` - przejście do następnej instrukcji (bez wchodzenia wewnątrz funkcji i skryptów)
* `s`, `stepInto` - przejście do następnej instrukcji (z wejściem do funkcji lub skryptu)
* `o`, `stepOut` - wyjście z funkcji 
* `c`, `continue` - kontynuowanie działania skryptu (do następnego zatrzymania)
* `l`, `list` - wyświetlenie kodu skryptu, z uwzględnieniem, na której linii jest on zatrzymany - linia oznaczona gwiazdką (szalenie przydatna komenda)

Pierwszy breakpoint zatrzyma kod na linii numer 9, gdzie pierwszy raz odwołujemy się do funkcji `Remove-Item`. W tym momencie możemy na przykład sprawdzić komendą `ls` jakie pliki znajdują się w katalogu, przejść krok dalej przy pomocy komendy `v`, ponownie przejrzeć zawartość katalogu i porównać czy faktycznie katalogi `packages` i `.vs` zostały usunięte. Gdy przejdziemy do kolejnych linii czy to poprzez kolejne wykonywania komendy `v` czy też `c`, wykonanie ponownie zatrzyma się na drugim wywołaniu funkcji `Remove-Item`. Tym razem należy jednak zwrócić uwagę, że w rzeczywistości kod zatrzymany zostanie już w linii 10 (a nie 11) bo mimo, że `Remove-Item` wywołane jest w linii 11 to z perspektywy Powershella jest to tak na prawdę jedno wyrażenie. Formatowanie nie znaczenia.

Drugi breakpoint zatrzyma kod na linii numer 12 kiedy odczytujemy wartość zmiennej `$currentDir` na potrzeby komendy `Set-Location`. Możemy w tym momencie sprawdzić co jest zapisane w zmiennej lub cokolwiek innego co może nam się przydać.
Wcześniejsze ustawienie wartości tej zmiennej w linii numer 7 nie spowoduje zatrzymania skryptu ponieważ tryb breakpointa ustawiliśmy jedynie na odczyt (`Read`). Jest to domyślna wartość. Moglibyśmy też ustawić breakpoint na odczyt i zapis (`ReadWrite`), albo sam zapis (`Write`).

Warto wspomnieć, że definiując breakpoint możemy podać listę czy to komend, czy nazw zmiennych, ale i tak dla każdego elementu będzie zarejestrowany osobny breakpoint. Aby się o tym przekonać wykonajmy poniższe polecenie:
```powershell
Set-PSBreakpoint -Command Get-ChildItem, Set-Location
```
Teraz możemy sprawdzić z pomocą komendy `Get-PSBreakpoint`, że faktycznie mamy dwa nowe breakpointy. Przy okazji, komenda ta może nam się też przydać kiedy chcemy jakiś breakpoint usunąć. Kiedy wylistujemy wszystkie breakpointy zauważymy, że każdy z nich ma przypisany numer ID, posługując się tym numerem możemy w prosty sposób usunąc wybrany breakpoint:
```powershell
Get-PSBreakpoint 2 | Remove-PSBreakpoint
Remove-PSBreakpoint 2 # efekt taki sam jak powyżej ;)
```
Równie łatwo możemy usunąć wszystkie nasze breakpointy:
```powershell
Get-PSBreakpoint | Remove-PSBreakpoint
```
Warto pamiętać, że po zamknięciu konsoli Powershella wszystkie zdefiniowane breakpointy się wykasują. Swoją drogą, jeśli debugujemy funkcję czy skrypt i jakiś breakpoint jest nam w danym momencie niepotrzebny, nie musimy być aż tak drastyczni i go usuwać. Z pomocą przychodzą nam dwie przydatne komendy: `Disbale-PSBreakpoint` oraz `Enable-PSBreakpoint`. Robią dokładnie to na co wskazuje ich nazwa :) Pierwsza powoduje, że dany breakpoint jest całkowicie zignorowany, a druga pownownie go aktywuje. Wystarczy przekazać im jeden argument - numer ID breakpointa, albo przekazać breakpoint poprzez pipeline (analogicznie jak w przypadku `Remove-PSBreakpoint`).

Na początku wspomniałem, że można też zdefiniować breakpoint dla konkretnej linii kodu. Faktycznie można, ale możemy to zrobić tylko dla wybranego skrypyt. Dla funkcji, którą napisaliśmy sobie i testujemy bezpośrednio w konsoli Powershella czegoś takiego nie możemy zrobić. Także, jeśli lubicie skopiować jakiś kod, wkleić do konsoli i się nim bawić (ja uwielbiam :D) to ten sposób debuggowania odpada. Na szczęście w bardzo łatwy sposób możemy przerobić funkcję na skrypt. Dla przykładu, nasza funkcja, którą na początku sobie zdefiniowaliśmy może przybrać poniższą formę:
```powershell
[cmdletbinding()]
Param (
    [string] $solutionDirectory
)

$currentDir = Get-Location
Set-Location $solutionDirectory
Remove-Item packages, .vs -Force -Recurse
Get-ChildItem bin, obj -Recurse |
    Remove-Item -Force -Recurse
Set-Location $currentDir
```
Zapisujemy kod do pliku, np `watch-process.ps1`, zakładamy breakpoint na przykład na linii numer 6 i uruchamiamy skrypt:
```powershell
Set-PSBreakpoint -Line 6 -Script watch-process.ps1
.\watch-process.ps1 .\ExampleVSSolution
```
Wykonanie skryptu powinno się zatrzymac na linii numer 6, pozostawiając w naszych rękach to co z nim zrobimy :) Warto wiedzieć, że dla danego skryptu również możemy zdefiniować breakpoint dla komendy czy zmiennej, nic nie stoi na przeszkodzie. 

Ostatnia rzecz o jakiej chciałem wspomnieć to parametr `-action`. Pozwala nam on tworzyć breakpointy, które zatrzymają kod na podstawie jakiegoś warunku, po angielsku na coś takiego mówi się często *conditional breakpoint*, bardzo przydatna rzecz. Możemy np. zdefiniować sobie breakpoint następująco:
```powershell
Set-PSBreakpoint -Script .\watch-process.ps1 -Command Remove-Item -Action { if(test-path packages){ break }}
```
Zatrzyma on kod przed wykonaniem komendy `Remove-Item`, tylko jeśli w folderze znajduje się katalog `packages`. W takim wypadku może nas bardziej interesować działanie skryptu niż wtedy kiedy katalogi, które ma za zadanie usunąć w ogóle nie istnieją. To tylko prosty przykład, ale możemy budować o wiele bardziej złożone warunki.

To by było na tyle, zachęcam wszystkich którzy korzystają z Powershella i piszą własne funkcje, moduły czy skrypty do korzystania z wbudowanych w język mechanizmów debuggowania bo są na prawdę wygodne i oferują bardzo duże możliwości - na pewno większe niż `Write-Output` czy `Write-Host` :)
