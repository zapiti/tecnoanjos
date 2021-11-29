import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjostec/app/app_bloc.dart';
import 'package:tecnoanjostec/app/app_widget.dart';

import 'package:tecnoanjostec/app/core/request_core.dart';
import 'package:tecnoanjostec/app/guard/router_login_guard.dart';
import 'package:tecnoanjostec/app/modules/default_page/widget/sidebar_menu..dart';

import 'package:tecnoanjostec/app/modules/general/home/modules/attendance/attendance_module.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/attendance/core/attendance_repository.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/avaliation/avaliation_module.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/call_heaven/call_heaven_module.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/chat_tecno_client/chat_tecno_client_module.dart';

import 'package:tecnoanjostec/app/modules/general/home/modules/faq/faq_module.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/help_center/help_center_module.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/onboarding/onboarding_module.dart';

import 'package:tecnoanjostec/app/modules/general/home/modules/payments/payments_module.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/profile/profile_module.dart';

import 'package:tecnoanjostec/app/modules/general/home/modules/settings/settings_module.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/table_money/table_money_module.dart';




import 'package:tecnoanjostec/app/routes/constants_routes.dart';

import 'guard/router_permission_guard.dart';

import 'modules/drawer/drawer_bloc.dart';
import 'modules/drawer/drawer_page.dart';


import 'modules/firebase/current_attendance/start_called/core/start_called_repository.dart';
import 'modules/firebase/current_attendance/start_called/start_called_bloc.dart';
import 'modules/firebase/current_attendance/start_called/start_called_module.dart';
import 'modules/general/finance/finance_module.dart';
import 'modules/general/home/home_module.dart';
import 'modules/general/home/modules/attendance/attendance_bloc.dart';
import 'modules/general/home/modules/call_heaven/call_heaven_bloc.dart';
import 'modules/general/home/modules/call_heaven/repository/call_heaven_repository.dart';
import 'modules/general/home/modules/chat_tecno_client/chat_attendance/chat_attendance_bloc.dart';
import 'modules/general/home/modules/chat_tecno_client/chat_attendance/core/chat_attendance_repository.dart';
import 'modules/general/home/modules/onboarding/onboarding_bloc.dart';
import 'modules/general/home/modules/profile/core/profile_repository.dart';
import 'modules/general/home/modules/profile/profile_bloc.dart';
import 'modules/general/home/modules/profile/widget/registre/registre_bloc.dart';
import 'modules/general/home/receiver_called/core/receiver_called_repository.dart';
import 'modules/general/home/receiver_called/receiver_called_bloc.dart';
import 'modules/general/information/information_module.dart';
import 'modules/general/login/bloc/login_bloc.dart';
import 'modules/general/login/login_module.dart';
import 'modules/general/login/repositories/auth_repository.dart';
import 'modules/general/sugestion/sugestion_module.dart';
import 'modules/notification/notification_bloc.dart';

import 'modules/splash_screean/splash_page.dart';

import 'utils/firebase/firebase_client_tecnoanjo.dart';
import 'utils/firebase/firebase_utils.dart';

class AppModule extends MainModule {
  @override
  List<Bind> get binds => [
        Bind((i) => ChatAttendanceBloc()),
        Bind((i) => ChatAttendanceRepository()),
        Bind((i) => SideBarMenu()),
        Bind((i) => DrawerBloc()),
        Bind((i) => DrawerPage()),
        Bind((i) => RegistreBloc()),
        Bind((i) => AttendanceBloc()),
        Bind((i) => AppBloc()),
        Bind((i) => LoginBloc()),
        Bind((i) => RequestCore()),
        Bind((i) => AuthRepository()),
        Bind((i) => ReceiverCalledBloc()),
        Bind((i) => ReceiverCalledRepository()),
        Bind((i) => ProfileBloc()),
        Bind((i) => ProfileRepository()),
        Bind((i) => StartCalledBloc()),
        Bind((i) => StartCalledRepository()),
        Bind((i) => CallHeavenBloc()),
        Bind((i) => CallHeavenRepository()),
        Bind((i) => FirebaseClientTecnoanjo()),
        Bind((i) => FirebaseUtils()),
        Bind((i) => OnboardingBloc()),
        Bind((i) => AttendanceRepository()),
        Bind((i) => NotificationBloc()),
        Bind((i) => ProfileRepository()),
        Bind((i) => Dio())
      ];

  @override
  List<ModularRouter> get routers => [
        !kIsWeb
            ? ModularRouter(Modular.initialRoute,
                child: (_, args) => SplashPage())
            : ModularRouter(Modular.initialRoute,
                module: LoginModule(), guards: [RouterLoginGuard()]),
        ModularRouter(ConstantsRoutes.SPLASH, child: (_, args) => SplashPage()),

        ModularRouter(ConstantsRoutes.HOMEPAGE,
            module: HomeModule(),
            transition: TransitionType.noTransition,
            guards: [RouterPermissionGuard()]),

        ModularRouter(ConstantsRoutes.LOGIN,
            module: LoginModule(), guards: [RouterLoginGuard()]),

        //chat
        ModularRouter(ConstantsRoutes.CHATTECNOCLIENT,
            module: ChatTecnoClientModule(),
            transition: TransitionType.noTransition,
            guards: [RouterPermissionGuard()]),


        //PAINEL DE CONTROLE FINANCEIRO
        ModularRouter(ConstantsRoutes.FINANCEIRO,
            module: FinanceModule(),
            transition: TransitionType.noTransition,
            guards: [RouterPermissionGuard()]),

        //PAINEL INFORMATIVO
        ModularRouter(ConstantsRoutes.INFORMATIVO,
            module: InformationModule(),
            transition: TransitionType.noTransition,
            guards: [RouterPermissionGuard()]),

        //PAINEL SUGESTOES
        ModularRouter(ConstantsRoutes.SUGESTIONS,
            module: SugestionModule(),
            transition: TransitionType.noTransition,
            guards: [RouterPermissionGuard()]),

        //Onboard
        ModularRouter(ConstantsRoutes.ONBOARD,
            module: OnboardingModule(),
            transition: TransitionType.downToUp,
            guards: [RouterPermissionGuard()]),



        //PERFIL
        ModularRouter(ConstantsRoutes.MEUPERFIL,
            module: ProfileModule(),
            transition: TransitionType.noTransition,
            guards: [RouterPermissionGuard()]),

        //TABELA DE VALORES
        ModularRouter(ConstantsRoutes.TABELA_DE_VALORES,
            module: TableMoneyModule(),
            transition: TransitionType.noTransition,
            guards: [RouterPermissionGuard()]),

//        //HORAS TRABALHADAS
//        Router(ConstantsRoutes.HORASTRABALHADAS,
//            module: HoursWorkedModule(),
//            transition: TransitionType.noTransition,
//            guards: [RouterPermissionGuard()]),

        //editar atendimento
        // ModularRouter(ConstantsRoutes.CALLING_EDITONLY,
        //     module: CallingEditOnlyModule(),
        //     transition: TransitionType.noTransition,
        //     guards: [RouterPermissionGuard()]),

        // //Carteira de clientes
        // ModularRouter(ConstantsRoutes.CARTEIRA_CLIENTES,
        //     module: ClientWalletModule(),
        //     transition: TransitionType.noTransition,
        //     guards: [RouterPermissionGuard()]),

        //AVALIACOES
        ModularRouter(ConstantsRoutes.AVALIACOES,
            module: AvaliationModule(),
            transition: TransitionType.noTransition,
            guards: [RouterPermissionGuard()]),

        //QUALIFICACOES
        // ModularRouter(ConstantsRoutes.QUALIFICACOES,
        //     module: QualificationsModule(),
        //     transition: TransitionType.noTransition,
        //     guards: [RouterPermissionGuard()]),

        // //REGIAO DE ATENDIMENTO
        // ModularRouter(ConstantsRoutes.REGIAOATENDIMENTO,
        //     module: RegionsAttendanceModule(),
        //     transition: TransitionType.noTransition,
        //     guards: [RouterPermissionGuard()]),

        // //HORARIO DE ATENDIMENTO
        // ModularRouter(ConstantsRoutes.HORARIOSATENDIMENTO,
        //     module: OpeningHoursModule(),
        //     transition: TransitionType.noTransition,
        //     guards: [RouterPermissionGuard()]),

        //MEUS ATENDIMENTOS
        ModularRouter(ConstantsRoutes.MEUSATENDIMENTOS,
            module: AttendanceModule(),
            transition: TransitionType.noTransition,
            guards: [RouterPermissionGuard()]),

        //MEUS PAGAMENTOS
        ModularRouter(ConstantsRoutes.MEUSPAGAMENTOS,
            module: PaymentsModule(),
            transition: TransitionType.noTransition,
            guards: [RouterPermissionGuard()]),

        //CONFIGURACOES
        ModularRouter(ConstantsRoutes.CONFIGURACOES,
            module: SettingsModule(),
            transition: TransitionType.noTransition,
            guards: [RouterPermissionGuard()]),

        //CENTRAL DE AJUDA
        ModularRouter(ConstantsRoutes.CENTRALDEAJUDA,
            module: HelpCenterModule(),
            transition: TransitionType.noTransition,
            guards: [RouterPermissionGuard()]),

        //CHAMAR CEU
        ModularRouter(ConstantsRoutes.CHAMARCEU,
            module: CallHeavenModule(),
            transition: TransitionType.noTransition,
            guards: [RouterPermissionGuard()]),

        //INICIAR CHAMADO
        ModularRouter(ConstantsRoutes.INICIARCHAMADO,
            module: StartCalledModule(),
            transition: TransitionType.noTransition,
            guards: [RouterPermissionGuard()]),

        //INICIAR CHAMADO
        ModularRouter(ConstantsRoutes.FAQ,
            module: FaqModule(),
            transition: TransitionType.noTransition,
            guards: [RouterPermissionGuard()]),
      ];

  @override
  Widget get bootstrap => AppWidget();

  static Inject get to => Inject<AppModule>.of();
}
