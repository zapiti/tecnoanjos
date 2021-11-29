import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjosclient/app/app_bloc.dart';
import 'package:tecnoanjosclient/app/app_widget.dart';
import 'package:tecnoanjosclient/app/core/request_core.dart';
import 'package:tecnoanjosclient/app/guard/router_login_guard.dart';
import 'package:tecnoanjosclient/app/guard/router_permission_guard.dart';
import 'package:tecnoanjosclient/app/modules/default_page/widget/sidebar_menu..dart';
import 'package:tecnoanjosclient/app/modules/drawer/drawer_bloc.dart';
import 'package:tecnoanjosclient/app/modules/firebase/current_attendance/start_called/core/start_called_repository.dart';
import 'package:tecnoanjosclient/app/routes/constants_routes.dart';
import 'package:tecnoanjosclient/app/utils/firebase/firebase_utils.dart';
import 'modules/drawer/drawer_page.dart';
import 'modules/firebase/current_attendance/start_called/start_called_bloc.dart';
import 'modules/general/home/home_module.dart';
import 'modules/general/home/modules/address/address_bloc.dart';
import 'modules/general/home/modules/address/core/address_repository.dart';
import 'modules/general/home/modules/attendance/attendance_bloc.dart';
import 'modules/general/home/modules/attendance/attendance_module.dart';
import 'modules/general/home/modules/attendance/core/attendance_repository.dart';
import 'modules/general/home/modules/avaliation/avaliation_module.dart';
import 'modules/general/home/modules/calling/calling_bloc.dart';
import 'modules/general/home/modules/calling/calling_module.dart';
import 'modules/general/home/modules/calling/core/calling_repository.dart';
import 'modules/general/home/modules/chat_tecno_client/chat_attendance/chat_attendance_bloc.dart';
import 'modules/general/home/modules/chat_tecno_client/chat_attendance/core/chat_attendance_repository.dart';
import 'modules/general/home/modules/chat_tecno_client/chat_tecno_client_module.dart';
import 'modules/general/home/modules/client_wallet/client_wallet_bloc.dart';
import 'modules/general/home/modules/client_wallet/client_wallet_module.dart';
import 'modules/general/home/modules/client_wallet/core/client_wallet_repository.dart';
import 'modules/general/home/modules/faq/faq_module.dart';
import 'modules/general/home/modules/help_center/help_center_module.dart';
import 'modules/general/home/modules/myaddress/core/my_address_repository.dart';
import 'modules/general/home/modules/myaddress/my_address_bloc.dart';
import 'modules/general/home/modules/myaddress/my_address_module.dart';
import 'modules/general/home/modules/payments/payments_module.dart';
import 'modules/general/home/modules/plains_services/plains_services_module.dart';
import 'modules/general/home/modules/profile/core/profile_repository.dart';
import 'modules/general/home/modules/profile/profile_bloc.dart';
import 'modules/general/home/modules/profile/profile_module.dart';
import 'modules/general/home/modules/settings/settings_module.dart';
import 'modules/general/home/modules/sugestion/sugestion_module.dart';
import 'modules/general/home/modules/wallet/core/wallet_repository.dart';
import 'modules/general/home/modules/wallet/wallet_bloc.dart';
import 'modules/general/home/modules/wallet/wallet_module.dart';
import 'modules/general/home/page/page_add_pendency.dart';
import 'modules/general/login/bloc/login_bloc.dart';
import 'modules/general/login/login_module.dart';
import 'modules/general/login/repositories/auth_repository.dart';
import 'modules/general/registre/registre_module.dart';
import 'modules/general/teste/teste_module.dart';
import 'modules/notification/notification_bloc.dart';
import 'modules/splash/splash_page.dart';

import 'utils/firebase/firebase_client_tecnoanjo.dart';

class AppModule extends MainModule {
  @override
  List<Bind> get binds => [
        Bind((i) => AppBloc()),
        Bind((i) => AddressBloc()),
        Bind((i) => ChatAttendanceBloc()),
        Bind((i) => ChatAttendanceRepository()),
        Bind((i) => AddressRepository()),
        Bind((i) => SideBarMenu()),
        Bind((i) => NotificationBloc()),
        Bind((i) => CallingBloc()),
        Bind((i) => CallingRepository()),
        Bind((i) => DrawerBloc()),
        Bind((i) => DrawerPage()),
        Bind((i) => FirebaseClientTecnoanjo()),
        Bind((i) => FirebaseUtils()),
        Bind((i) => AttendanceBloc()),
        Bind((i) => AttendanceRepository()),
        Bind((i) => LoginBloc()),
        Bind((i) => RequestCore()),
        Bind((i) => AuthRepository()),
        Bind((i) => ProfileBloc()),
        Bind((i) => ProfileRepository()),
        Bind((i) => MyAddressBloc()),
        Bind((i) => MyAddressRepository()),
        Bind((i) => StartCalledBloc()),
        Bind((i) => ClientWalletBloc()),
        Bind((i) => ClientWalletRepository()),
        Bind((i) => StartCalledRepository()),
        Bind((i) => WalletBloc()),
        Bind((i) => WalletRepository()),
        Bind((i) => Dio())
      ];

  @override
  List<ModularRouter> get routers => [
        kIsWeb
            ? ModularRouter(Modular.initialRoute,
                module: LoginModule(), guards: [RouterLoginGuard()])
            : ModularRouter(
                Modular.initialRoute,
                child: (_, args) => SplashPage(),
                transition: TransitionType.fadeIn,
              ),
        ModularRouter(ConstantsRoutes.SPLASH, child: (_, args) => SplashPage()),

        ModularRouter(ConstantsRoutes.HOMEPAGE,
            module: HomeModule(),
            transition: TransitionType.fadeIn,
            guards: [RouterPermissionGuard()]),
        ModularRouter(ConstantsRoutes.LOGIN,
            module: LoginModule(), guards: [RouterLoginGuard()]),

        //PAINEL SUGESTOES
        ModularRouter(ConstantsRoutes.SUGESTIONS,
            module: SugestionModule(),
            transition: TransitionType.fadeIn,
            guards: [RouterPermissionGuard()]),

        ModularRouter(ConstantsRoutes.PENDENCY,
            child: (_, args) => PageAddPendency(args.data)),

        //planos
        ModularRouter(ConstantsRoutes.PLAINS,
            module: PlainsServicesModule(),
            transition: TransitionType.fadeIn,
            guards: [RouterPermissionGuard()]),

        //chat
        ModularRouter(ConstantsRoutes.CHATTECNOCLIENT,
            module: ChatTecnoClientModule(),
            transition: TransitionType.fadeIn,
            guards: [RouterPermissionGuard()]),

        //Carteira de clientes
        ModularRouter(ConstantsRoutes.CARTEIRA_CLIENTES,
            module: ClientWalletModule(),
            transition: TransitionType.fadeIn,
            guards: [RouterPermissionGuard()]),

        //Registre
        ModularRouter(ConstantsRoutes.REGISTRE,
            module: RegistreModule(), transition: TransitionType.fadeIn),

        //Carteira
        ModularRouter(ConstantsRoutes.CARTEIRA,
            module: WalletModule(),
            transition: TransitionType.fadeIn,
            guards: [RouterPermissionGuard()]),

        //enderecos
        ModularRouter(ConstantsRoutes.ENDERECOS,
            module: MyAddressModule(),
            transition: TransitionType.fadeIn,
            guards: [RouterPermissionGuard()]),

        //Onboard
        ModularRouter(ConstantsRoutes.CALLING,
            module: CallingModule(),
            transition: TransitionType.fadeIn,
            guards: [RouterPermissionGuard()]),

        //PERFIL
        ModularRouter(ConstantsRoutes.MEUPERFIL,
            module: ProfileModule(),
            transition: TransitionType.fadeIn,
            guards: [RouterPermissionGuard()]),

        //AVALIACOES
        ModularRouter(ConstantsRoutes.AVALIACOES,
            module: AvaliationModule(),
            transition: TransitionType.fadeIn,
            guards: [RouterPermissionGuard()]),

        //MEUS ATENDIMENTOS
        ModularRouter(ConstantsRoutes.MEUSATENDIMENTOS,
            module: AttendanceModule(),
            transition: TransitionType.fadeIn,
            guards: [RouterPermissionGuard()]),

        //MEUS PAGAMENTOS
        ModularRouter(ConstantsRoutes.MEUSPAGAMENTOS,
            module: PaymentsModule(),
            transition: TransitionType.fadeIn,
            guards: [RouterPermissionGuard()]),

        //CONFIGURACOES
        ModularRouter(ConstantsRoutes.CONFIGURACOES,
            module: SettingsModule(),
            transition: TransitionType.fadeIn,
            guards: [RouterPermissionGuard()]),

        //CENTRAL DE AJUDA
        ModularRouter(ConstantsRoutes.CENTRALDEAJUDA,
            module: HelpCenterModule(),
            transition: TransitionType.fadeIn,
            guards: [RouterPermissionGuard()]),

        //INICIAR CHAMADO
        ModularRouter(ConstantsRoutes.FAQ,
            module: FaqModule(),
            transition: TransitionType.fadeIn,
            guards: [RouterPermissionGuard()]),


        //TESTE
        ModularRouter(ConstantsRoutes.TESTE,
            module: TesteModule(),
            transition: TransitionType.fadeIn,
            guards: [RouterPermissionGuard()]),

      ];

  @override
  Widget get bootstrap => AppWidget();

  static Inject get to => Inject<AppModule>.of();
}
