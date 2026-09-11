# UI/UX Pro Max - Multi-Theme Peak & Funny Lunch Reminder
Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase

$themes = @(
    @{
        Id = 'CYBERPUNK'
        Badge = '🔴 INCIDENT SEV-1: HUMAN_STARVATION'
        BadgeColor = '#eb6f92'
        Icon = '🍱'
        IconBg = '#35eb6f92'
        IconBorder = '#80eb6f92'
        Title = 'Dạ dày đang báo lỗi 404! 🍚'
        SubTitle = 'Phát hiện Developer đang cạn kiệt glucose và carb.'
        Stat1Title = '🔋 Năng lượng'
        Stat1Val = '3% (Báo động)'
        Stat1Color = '#eb6f92'
        Stat2Title = '🧠 Ping não bộ'
        Stat2Val = '999ms (Lag giật)'
        Stat2Color = '#f6c177'
        Stat3Title = '💡 Gợi ý cứu đói'
        Stat3Val = 'Cơm tấm sườn bì chả 🍳'
        Stat3Color = '#a6da95'
        Quote = 'Bug không tự hết nhưng đói thì run tay đấy! Dậy ăn cơm sếp ơi 🍚'
        BtnConfirm = '🍚 Đi ăn cứu lấy dạ dày'
        BtnConfirmGrad1 = '#a6da95'
        BtnConfirmGrad2 = '#8bd5ca'
        BtnDismiss = '☕ Cố 5p nữa (Nguy cơ to)'
    },
    @{
        Id = 'RPG_QUEST'
        Badge = '⚔️ EMERGENCY QUEST: TIÊU DIỆT CƠN ĐÓI'
        BadgeColor = '#f6c177'
        Icon = '🍖'
        IconBg = '#35f6c177'
        IconBorder = '#80f6c177'
        Title = 'Hiệp sĩ ơi! HP của bạn còn 5%! 🛡️'
        SubTitle = 'Quái vật "Cơn Đói Bụng" đã kích hoạt debuff -90% Trí Tuệ.'
        Stat1Title = '❤️ Lượng máu (HP)'
        Stat1Val = '5/100 (Nguy kịch)'
        Stat1Color = '#eb6f92'
        Stat2Title = '🧪 Lượng Mana'
        Stat2Val = '0/100 (Cạn sạch)'
        Stat2Color = '#908caa'
        Stat3Title = '🎁 Phần thưởng'
        Stat3Val = '+9999 Trí Lực và Tỉnh Táo'
        Stat3Color = '#f6c177'
        Quote = 'Code cả đời chứ không ai nhịn ăn được cả đời! Nhận quest đi ăn thôi hiệp sĩ 🍗'
        BtnConfirm = '⚔️ Nhận Quest: Đi ăn ngay!'
        BtnConfirmGrad1 = '#f6c177'
        BtnConfirmGrad2 = '#ea9a97'
        BtnDismiss = '🏃 Bỏ chạy (Ráng gõ phím)'
    },
    @{
        Id = 'GIT_CICD'
        Badge = '❌ PIPELINE FAILED: HUMAN_METABOLISM'
        BadgeColor = '#eb6f92'
        Icon = '💥'
        IconBg = '#35eb6f92'
        IconBorder = '#80eb6f92'
        Title = 'Build Failed: Exit Code 137 (OOM) ⚙️'
        SubTitle = 'Job "compile_brain_logic" bị terminate do dạ dày rỗng quá lâu.'
        Stat1Title = '🌿 Git Branch'
        Stat1Val = 'fix/dead-hunger'
        Stat1Color = '#89b4fa'
        Stat2Title = '❌ Error Cause'
        Stat2Val = 'ZeroCarbsException'
        Stat2Color = '#eb6f92'
        Stat3Title = '💡 Recommended Fix'
        Stat3Val = 'Phở bò tái lăn nóng hổi 🍜'
        Stat3Color = '#a6da95'
        Quote = 'Cơm sườn 35k đang vẫy gọi, gõ cố thêm dòng nữa khéo drop database đấy 🥩'
        BtnConfirm = '🚀 Git Stash và Đi Ăn Ngay'
        BtnConfirmGrad1 = '#89b4fa'
        BtnConfirmGrad2 = '#a6da95'
        BtnDismiss = '💥 Force Push liều mạng'
    },
    @{
        Id = 'AI_LIMIT'
        Badge = '🤖 SYSTEM 429: TOKEN QUOTA EXHAUSTED'
        BadgeColor = '#c4a7e7'
        Icon = '🧠'
        IconBg = '#35c4a7e7'
        IconBorder = '#80c4a7e7'
        Title = 'Não bộ quá tải: Rate Limit 0 RPM! ⚡'
        SubTitle = 'Model "Human-Dev-Core" cạn kiệt token calo. Cần prompt đồ ăn.'
        Stat1Title = '⚡ Calo Tokens'
        Stat1Val = '0 / 2,000 kcal'
        Stat1Color = '#eb6f92'
        Stat2Title = '🔥 Core Temp'
        Stat2Val = '100°C (Quá nóng)'
        Stat2Color = '#f6c177'
        Stat3Title = '💡 Best Prompt'
        Stat3Val = '1 dĩa cơm gà xối mỡ 🍗'
        Stat3Color = '#c4a7e7'
        Quote = 'Exception in thread "Human": EmptyStomachException at Brain.Think() 🤯'
        BtnConfirm = '⚡ Top-up Calo Ngay'
        BtnConfirmGrad1 = '#c4a7e7'
        BtnConfirmGrad2 = '#eb6f92'
        BtnDismiss = '⏳ Chờ Cooldown (Ngủ gục)'
    },
    @{
        Id = 'BSOD_PANIC'
        Badge = '💻 KERNEL PANIC: NO_STOMACH_CARBS'
        BadgeColor = '#89dceb'
        Icon = '🪟'
        IconBg = '#3589dceb'
        IconBorder = '#8089dceb'
        Title = 'Your Body Ran Into A Problem :( ⚠️'
        SubTitle = 'Hệ điều hành cơ thể cần nạp tinh bột khẩn cấp để tránh shut down.'
        Stat1Title = '🛑 Stop Code'
        Stat1Val = 'HUNGER_CRITICAL'
        Stat1Color = '#eb6f92'
        Stat2Title = '📄 What Failed'
        Stat2Val = 'stomach.sys'
        Stat2Color = '#f6c177'
        Stat3Title = '💡 Restore Point'
        Stat3Val = 'Bún chả nem cua bể 🍲'
        Stat3Color = '#89dceb'
        Quote = 'Fix bug có thể đợi sprint sau, dạ dày viêm thì không thể roll-back! 🏃‍♂️💨'
        BtnConfirm = '🔄 Reboot Cơ Thể (Ăn Trưa)'
        BtnConfirmGrad1 = '#89dceb'
        BtnConfirmGrad2 = '#74c7ec'
        BtnDismiss = '🛑 Ignore và Crash'
    }
)

# Random 1 theme
$t = $themes[(Get-Random -Minimum 0 -Maximum $themes.Length)]

$badgeColor = $t.BadgeColor
$badge = [System.Security.SecurityElement]::Escape($t.Badge)
$icon = $t.Icon
$iconBg = $t.IconBg
$iconBorder = $t.IconBorder
$title = [System.Security.SecurityElement]::Escape($t.Title)
$subTitle = [System.Security.SecurityElement]::Escape($t.SubTitle)
$s1Title = [System.Security.SecurityElement]::Escape($t.Stat1Title)
$s1Val = [System.Security.SecurityElement]::Escape($t.Stat1Val)
$s1Col = $t.Stat1Color
$s2Title = [System.Security.SecurityElement]::Escape($t.Stat2Title)
$s2Val = [System.Security.SecurityElement]::Escape($t.Stat2Val)
$s2Col = $t.Stat2Color
$s3Title = [System.Security.SecurityElement]::Escape($t.Stat3Title)
$s3Val = [System.Security.SecurityElement]::Escape($t.Stat3Val)
$s3Col = $t.Stat3Color
$quote = [System.Security.SecurityElement]::Escape($t.Quote)
$btnConfirmText = [System.Security.SecurityElement]::Escape($t.BtnConfirm)
$grad1 = $t.BtnConfirmGrad1
$grad2 = $t.BtnConfirmGrad2
$btnDismissText = [System.Security.SecurityElement]::Escape($t.BtnDismiss)

$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="System Lunch Alert"
        Width="540" Height="370"
        WindowStyle="None"
        AllowsTransparency="True"
        Background="Transparent"
        WindowStartupLocation="CenterScreen"
        Topmost="True"
        ShowInTaskbar="False"
        FontFamily="Segoe UI Variable Display, Segoe UI, sans-serif">

    <!-- Main Card Body with Spring Animation on Root Grid -->
    <Grid Margin="20" RenderTransformOrigin="0.5,0.5">
        <Grid.RenderTransform>
            <ScaleTransform x:Name="GridScale" ScaleX="1" ScaleY="1"/>
        </Grid.RenderTransform>
        <Grid.Triggers>
            <EventTrigger RoutedEvent="Grid.Loaded">
                <BeginStoryboard>
                    <Storyboard>
                        <DoubleAnimation Storyboard.TargetProperty="Opacity" From="0" To="1" Duration="0:0:0.22"/>
                        <DoubleAnimation Storyboard.TargetName="GridScale" Storyboard.TargetProperty="ScaleX" From="0.92" To="1" Duration="0:0:0.25">
                            <DoubleAnimation.EasingFunction>
                                <BackEase EasingMode="EaseOut" Amplitude="0.25"/>
                            </DoubleAnimation.EasingFunction>
                        </DoubleAnimation>
                        <DoubleAnimation Storyboard.TargetName="GridScale" Storyboard.TargetProperty="ScaleY" From="0.92" To="1" Duration="0:0:0.25">
                            <DoubleAnimation.EasingFunction>
                                <BackEase EasingMode="EaseOut" Amplitude="0.25"/>
                            </DoubleAnimation.EasingFunction>
                        </DoubleAnimation>
                    </Storyboard>
                </BeginStoryboard>
            </EventTrigger>
        </Grid.Triggers>

        <Border CornerRadius="22"
                BorderThickness="1.2"
                BorderBrush="#4a4563">
            <Border.Background>
                <LinearGradientBrush StartPoint="0,0" EndPoint="1,1">
                    <GradientStop Color="#232038" Offset="0.0"/>
                    <GradientStop Color="#191724" Offset="0.6"/>
                    <GradientStop Color="#13111c" Offset="1.0"/>
                </LinearGradientBrush>
            </Border.Background>
            <Border.Effect>
                <DropShadowEffect Color="#000000" BlurRadius="30" ShadowDepth="10" Opacity="0.7"/>
            </Border.Effect>

            <Grid Margin="24,20,24,20">
                <Grid.RowDefinitions>
                    <RowDefinition Height="Auto"/>
                    <RowDefinition Height="Auto"/>
                    <RowDefinition Height="*"/>
                    <RowDefinition Height="Auto"/>
                </Grid.RowDefinitions>

                <!-- 1. TOP STATUS BAR -->
                <DockPanel Grid.Row="0" LastChildFill="False" Margin="0,0,0,14">
                    <StackPanel Orientation="Horizontal" DockPanel.Dock="Left" VerticalAlignment="Center">
                        <Border Width="8" Height="8" CornerRadius="4" Background="$badgeColor" Margin="0,0,8,0"/>
                        <TextBlock Text="$badge"
                                   FontSize="11"
                                   FontWeight="Bold"
                                   Foreground="$badgeColor"/>
                    </StackPanel>

                    <StackPanel Orientation="Horizontal" DockPanel.Dock="Right">
                        <Border Background="#26233a" CornerRadius="6" Padding="6,2" Margin="0,0,8,0" BorderThickness="1" BorderBrush="#3e3859">
                            <TextBlock Text="ESC" FontSize="10" FontWeight="Bold" Foreground="#908caa" FontFamily="Consolas"/>
                        </Border>
                        <Button x:Name="ActionCloseIcon"
                                Content="✕"
                                Width="26" Height="26"
                                FontSize="12"
                                FontWeight="Bold"
                                Foreground="#6e6a86"
                                Background="#26233a"
                                BorderThickness="0"
                                Cursor="Hand">
                            <Button.Resources>
                                <Style TargetType="Border">
                                    <Setter Property="CornerRadius" Value="13"/>
                                </Style>
                            </Button.Resources>
                        </Button>
                    </StackPanel>
                </DockPanel>

                <!-- 2. HERO: Dynamic Icon + Heading -->
                <Grid Grid.Row="1" Margin="0,0,0,14">
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="Auto"/>
                        <ColumnDefinition Width="*"/>
                    </Grid.ColumnDefinitions>

                    <Border Grid.Column="0"
                            Width="52" Height="52"
                            CornerRadius="16"
                            Background="$iconBg"
                            BorderBrush="$iconBorder"
                            BorderThickness="1.5"
                            Margin="0,0,16,0">
                        <TextBlock Text="$icon" FontSize="26" HorizontalAlignment="Center" VerticalAlignment="Center"/>
                    </Border>

                    <StackPanel Grid.Column="1" VerticalAlignment="Center">
                        <TextBlock Text="$title"
                                   FontSize="18.5"
                                   FontWeight="Bold"
                                   Foreground="#f8f8fc"/>
                        <TextBlock Text="$subTitle"
                                   FontSize="12.5"
                                   Foreground="#908caa"
                                   Margin="0,2,0,0"/>
                    </StackPanel>
                </Grid>

                <!-- 3. DEV DIAGNOSTIC HUD: 3 Telemetry chips + Quote -->
                <Border Grid.Row="2"
                        Background="#12101b"
                        BorderBrush="#2c283e"
                        BorderThickness="1.2"
                        CornerRadius="14"
                        Padding="14,10"
                        Margin="0,0,0,16">
                    <Grid>
                        <Grid.RowDefinitions>
                            <RowDefinition Height="Auto"/>
                            <RowDefinition Height="Auto"/>
                            <RowDefinition Height="*"/>
                        </Grid.RowDefinitions>

                        <UniformGrid Grid.Row="0" Columns="3" Margin="0,2,0,10">
                            <StackPanel>
                                <TextBlock Text="$s1Title" FontSize="11" Foreground="#6e6a86"/>
                                <TextBlock Text="$s1Val" FontSize="11.5" FontWeight="Bold" Foreground="$s1Col" Margin="0,2,0,0"/>
                            </StackPanel>

                            <StackPanel>
                                <TextBlock Text="$s2Title" FontSize="11" Foreground="#6e6a86"/>
                                <TextBlock Text="$s2Val" FontSize="11.5" FontWeight="Bold" Foreground="$s2Col" Margin="0,2,0,0"/>
                            </StackPanel>

                            <StackPanel>
                                <TextBlock Text="$s3Title" FontSize="11" Foreground="#6e6a86"/>
                                <TextBlock Text="$s3Val" FontSize="11.5" FontWeight="SemiBold" Foreground="$s3Col" Margin="0,2,0,0" TextTrimming="CharacterEllipsis"/>
                            </StackPanel>
                        </UniformGrid>

                        <Border Grid.Row="1" Height="1" Background="#211e30" Margin="0,0,0,8"/>

                        <TextBlock Grid.Row="2"
                                   Text="$quote"
                                   FontSize="12.5"
                                   FontStyle="Italic"
                                   Foreground="#e0def4"
                                   TextWrapping="Wrap"
                                   VerticalAlignment="Center"/>
                    </Grid>
                </Border>

                <!-- 4. ACTION BAR -->
                <Grid Grid.Row="3">
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="1.4*"/>
                        <ColumnDefinition Width="12"/>
                        <ColumnDefinition Width="1*"/>
                    </Grid.ColumnDefinitions>

                    <Button x:Name="ActionConfirm"
                            Grid.Column="0"
                            Height="42"
                            BorderThickness="0"
                            Cursor="Hand">
                        <Button.Background>
                            <LinearGradientBrush StartPoint="0,0" EndPoint="1,0">
                                <GradientStop Color="$grad1" Offset="0.0"/>
                                <GradientStop Color="$grad2" Offset="1.0"/>
                            </LinearGradientBrush>
                        </Button.Background>
                        <Button.Resources>
                            <Style TargetType="Border">
                                <Setter Property="CornerRadius" Value="12"/>
                            </Style>
                        </Button.Resources>
                        <StackPanel Orientation="Horizontal" HorizontalAlignment="Center" VerticalAlignment="Center">
                            <TextBlock Text="$btnConfirmText"
                                       FontWeight="Bold"
                                       FontSize="13"
                                       Foreground="#191724"
                                       Margin="0,0,8,0"/>
                            <Border Background="#30191724" CornerRadius="6" Padding="6,2">
                                <TextBlock Text="⏎ Enter" FontSize="10" FontWeight="Bold" Foreground="#191724" FontFamily="Consolas"/>
                            </Border>
                        </StackPanel>
                    </Button>

                    <Button x:Name="ActionDismiss"
                            Grid.Column="2"
                            Height="42"
                            Background="#26233a"
                            BorderBrush="#3e3859"
                            BorderThickness="1.2"
                            Cursor="Hand">
                        <Button.Resources>
                            <Style TargetType="Border">
                                <Setter Property="CornerRadius" Value="12"/>
                            </Style>
                        </Button.Resources>
                        <StackPanel Orientation="Horizontal" HorizontalAlignment="Center" VerticalAlignment="Center">
                            <TextBlock Text="$btnDismissText"
                                       FontWeight="SemiBold"
                                       FontSize="12.5"
                                       Foreground="#908caa"
                                       Margin="0,0,6,0"/>
                            <Border Background="#191724" CornerRadius="6" Padding="5,2" BorderThickness="1" BorderBrush="#3e3859">
                                <TextBlock Text="Esc" FontSize="10" FontWeight="Bold" Foreground="#6e6a86" FontFamily="Consolas"/>
                            </Border>
                        </StackPanel>
                    </Button>
                </Grid>
            </Grid>
        </Border>
    </Grid>
</Window>
"@

$reader = [System.Xml.XmlReader]::Create([System.IO.StringReader]::new($xaml))
$window = [System.Windows.Markup.XamlReader]::Load($reader)

# Window Dragging
$window.Add_MouseDown({
    if ($_.ChangedButton -eq [System.Windows.Input.MouseButton]::Left) {
        $window.DragMove()
    }
})

# Close logic
$closeAction = { $window.Close() }

$btn1 = $window.FindName("ActionConfirm")
$btn2 = $window.FindName("ActionDismiss")
$btn3 = $window.FindName("ActionCloseIcon")

if ($btn1) { $btn1.Add_Click($closeAction) }
if ($btn2) { $btn2.Add_Click($closeAction) }
if ($btn3) { $btn3.Add_Click($closeAction) }

# Keyboard shortcuts: Enter = Confirm, Esc = Close
$window.Add_KeyDown({
    if ($_.Key -eq [System.Windows.Input.Key]::Escape -or $_.Key -eq [System.Windows.Input.Key]::Enter) {
        $window.Close()
    }
})

[void]$window.ShowDialog()
