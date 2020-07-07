/* Layouts */
import ApplicationLayout from 'containers/Layouts/ApplicationLayout/Loadable';
import AuthenticatedLayout from 'containers/Layouts/AuthenticatedLayout/Loadable';
import UserLayout from 'containers/Layouts/UserLayout/Loadable';
import GroupLayout from 'containers/Layouts/GroupLayout/Loadable';
import AdminLayout from 'containers/Layouts/AdminLayout/Loadable';
import SessionLayout from 'containers/Layouts/SessionLayout/Loadable';
import ResponseLayout from 'containers/Layouts/ResponseLayout/Loadable';
import ErrorLayout from 'containers/Layouts/ErrorLayout/Loadable';
import GlobalSettingsLayout from 'containers/Layouts/GlobalSettingsLayout/Loadable';
import GroupManageLayout from 'containers/Layouts/GroupManageLayout/Loadable';
import GroupPlanLayout from 'containers/Layouts/GroupPlanLayout/Loadable';
import GroupKPILayout from 'containers/Layouts/GroupPlanLayout/KPILayout/Loadable';
import GroupBudgetLayout from 'containers/Layouts/GroupPlanLayout/BudgetingLayout/Loadable';
import MentorshipLayout from 'containers/Layouts/MentorshipLayout/Loadable';
import InnovateLayout from 'containers/Layouts/InnovateLayout/Loadable';
import SystemUserLayout from 'containers/Layouts/SystemUsersLayout/Loadable';
import BrandingLayout from 'containers/Layouts/BrandingLayout/Loadable';
import EmailLayout from 'containers/Layouts/GlobalSettingsLayout/EmailLayout/Loadable';

/* Session */
import LoginPage from 'containers/Session/LoginPage/Loadable';
import SignUpPage from 'containers/User/SignUpPage/Loadable';
import ForgotPasswordPage from 'containers/Session/ForgotPasswordPage/Loadable';

/* User */
import HomePage from 'containers/User/HomePage/Loadable';
import UserGroupListPage from 'containers/Group/UserGroupListPage/Loadable';
import UserProfilePage from 'containers/User/UserProfilePage/Loadable';
import UserNewsLinkPage from 'containers/User/UserNewsFeedPage/Loadable';
import UserEventsPage from 'containers/User/UserEventsPage/Loadable';
import UserDownloadsPage from 'containers/User/UserDownloadsPage/Loadable';

/* User - Mentorship */
import MentorshipProfilePage from 'containers/Mentorship/MentorshipProfilePage/Loadable';
import MentorshipEditProfilePage from 'containers/Mentorship/MentorshipEditProfilePage/Loadable';
import MentorsPage from 'containers/Mentorship/Mentoring/MentorsPage/Loadable';
import MentorRequestsPage from 'containers/Mentorship/Requests/RequestsPage/Loadable';
import SessionsPage from 'containers/Mentorship/Session/SessionsPage/Loadable';
import SessionPage from 'containers/Mentorship/Session/SessionPage/Loadable';
import SessionsEditPage from 'containers/Mentorship/Session/SessionEditPage/Loadable';

/* Admin - Analyze */
import GroupDashboardPage from 'containers/Analyze/Dashboards/GroupDashboardPage/Loadable';
import UserDashboardPage from 'containers/Analyze/Dashboards/UserDashboardPage/Loadable';

/* Admin - Plan */
import AdminAnnualBudgetPage from 'containers/Group/GroupPlan/AnnualBudget/AdminPlanAnnualBudgetPage/Loadable';

/* Admin - Analyze - Custom */
import MetricsDashboardListPage from 'containers/Analyze/Dashboards/MetricsDashboard/MetricsDashboardListPage/Loadable';
import MetricsDashboardCreatePage from 'containers/Analyze/Dashboards/MetricsDashboard/MetricsDashboardCreatePage/Loadable';
import MetricsDashboardEditPage from 'containers/Analyze/Dashboards/MetricsDashboard/MetricsDashboardEditPage/Loadable';
import MetricsDashboardPage from 'containers/Analyze/Dashboards/MetricsDashboard/MetricsDashboardPage/Loadable';
import CustomGraphCreatePage from 'containers/Analyze/Dashboards/MetricsDashboard/CustomGraph/CustomGraphCreatePage/Loadable';
import CustomGraphEditPage from 'containers/Analyze/Dashboards/MetricsDashboard/CustomGraph/CustomGraphEditPage/Loadable';

/* Admin - Manage - Group */
import AdminGroupListPage from 'containers/Group/AdminGroupListPage/Loadable';
import GroupCreatePage from 'containers/Group/GroupCreatePage/Loadable';
import GroupEditPage from 'containers/Group/GroupEditPage/Loadable';
import GroupCategoriesPage from 'containers/Group/GroupCategories/GroupCategoriesPage/Loadable';
import GroupCategoriesCreatePage from 'containers/Group/GroupCategories/GroupCategoriesCreatePage/Loadable';
import GroupCategoriesEditPage from 'containers/Group/GroupCategories/GroupCategoriesEditPage/Loadable';
import GroupCategorizePage from 'containers/Group/GroupCategorizePage/Loadable';

/* Admin - Manage - Segment */
import SegmentListPage from 'containers/Segment/SegmentListPage/Loadable';
import SegmentPage from 'containers/Segment/SegmentPage/Loadable';

/* Admin - Manage - Archive */
import ArchivesPage from 'containers/Archive/ArchivesPage/Loadable';

/* Admin - Manage - Calendar */
import AdminCalendarPage from 'containers/Calendar/AdminCalendarPage';

/* Admin - Include - Polls */
import PollsList from 'containers/Poll/PollListPage/Loadable';
import PollCreatePage from 'containers/Poll/PollCreatePage/Loadable';
import PollEditPage from 'containers/Poll/PollEditPage/Loadable';
import PollShowPage from 'containers/Poll/PollShowPage/Loadable';
import PollResponsePage from 'containers/Poll/PollResponsePage/Loadable';

/* Admin - System - Global Settings */
import FieldsPage from 'containers/GlobalSettings/Field/FieldsPage/Loadable';
import CustomTextEditPage from 'containers/GlobalSettings/CustomText/CustomTextEditPage/Loadable';
import EnterpriseConfigurationPage from 'containers/GlobalSettings/EnterpriseConfiguration/EnterpriseConfigurationPage/Loadable';
import SSOSettingsPage from 'containers/GlobalSettings/SSOSettingsPage/Loadable';
import EmailsPage from 'containers/GlobalSettings/Email/Email/EmailsPage/Loadable';
import EmailEditPage from 'containers/GlobalSettings/Email/Email/EmailEditPage/Loadable';
import EmailEventsPage from 'containers/GlobalSettings/Email/Event/EventsPage/Loadable';
import EmailEventEditPage from 'containers/GlobalSettings/Email/Event/EventEditPage/Loadable';
import PolicyTemplatesPage from 'containers/User/UserPolicy/PolicyTemplatesPage/Loadable';
import PolicyTemplateEditPage from 'containers/User/UserPolicy/PolicyTemplateEditPage/Loadable';

/* Admin - System - Branding */
import BrandingThemePage from 'containers/Branding/BrandingThemePage/Loadable';
import BrandingHomePage from 'containers/Branding/BrandingHomePage/Loadable';
import SponsorListPage from 'containers/Branding/Sponsor/SponsorListPage/Loadable';
import SponsorCreatePage from 'containers/Branding/Sponsor/SponsorCreatePage/Loadable';
import SponsorEditPage from 'containers/Branding/Sponsor/SponsorEditPage/Loadable';

/* Admin - System - User */
import UsersPage from 'containers/User/UsersPage/Loadable';
import UsersImportPage from 'containers/User/UsersImportPage/Loadable';
import UserCreatePage from 'containers/User/UserCreatePage/Loadable';
import UserEditPage from 'containers/User/UserEditPage/Loadable';

/* Admin - System - User - Roles */
import UserRolesListPage from 'containers/User/UserRole/UserRoleListPage/Loadable';
import UserRoleCreatePage from 'containers/User/UserRole/UserRoleCreatePage/Loadable';
import UserRoleEditPage from 'containers/User/UserRole/UserRoleEditPage/Loadable';

/* Admin - System - Logs */
import LogListPage from 'containers/Log/LogListPage/Loadable';

/* Group */
import GroupHomePage from 'containers/Group/GroupHomePage/Loadable';
import EventsPage from 'containers/Event/EventsPage/Loadable';
import NewsFeedPage from 'containers/News/NewsFeedPage/Loadable';
import OutcomesPage from 'containers/Group/Outcome/OutcomesPage/Loadable';

/* Group - Events */
import EventPage from 'containers/Event/EventPage/Loadable';
import EventCreatePage from 'containers/Event/EventCreatePage/Loadable';
import EventEditPage from 'containers/Event/EventEditPage/Loadable';
import EventManageMetricsPage from 'containers/Event/EventManage/MetricsPage/Loadable';
import EventManageLayout from 'containers/Layouts/EventManageLayout/Loadable';
import EventManageFieldsPage from 'containers/Event/EventManage/FieldsPage/Loadable';
import EventManageUpdatesPage from 'containers/Event/EventManage/UpdatesPage/Loadable';
import EventManageUpdatePage from 'containers/Event/EventManage/UpdatePage/Loadable';
import EventManageUpdateEditPage from 'containers/Event/EventManage/UpdateEditPage/Loadable';
import EventManageUpdateCreatePage from 'containers/Event/EventManage/UpdateCreatePage/Loadable';
import EventManageExpensesPage from 'containers/Event/EventManage/Expense/ExpensesPage/Loadable';
import EventManageExpenseCreatePage from 'containers/Event/EventManage/Expense/ExpenseCreatePage/Loadable';
import EventManageExpenseEditPage from 'containers/Event/EventManage/Expense/ExpenseEditPage/Loadable';

/* Group - News Feed */
import GroupMessagePage from 'containers/News/GroupMessage/GroupMessagePage/Loadable';
import GroupMessageCreatePage from 'containers/News/GroupMessage/GroupMessageCreatePage/Loadable';
import GroupMessageEditPage from 'containers/News/GroupMessage/GroupMessageEditPage/Loadable';
import NewsLinkCreatePage from 'containers/News/NewsLink/NewsLinkCreatePage';
import NewsLinkEditPage from 'containers/News/NewsLink/NewsLinkEditPage';
import SocialLinkCreatePage from 'containers/News/SocialLink/SocialLinkCreatePage';
import SocialLinkEditPage from 'containers/News/SocialLink/SocialLinkEditPage';
import NewsLinkPage from 'containers/News/NewsLink/NewsLinkPage';

/* Group - Plan - Events */
import GroupPlanEventsPage from 'containers/Group/GroupPlan/EventsPage/Loadable';

/* Group - Plan - Outcomes */
import OutcomeCreatePage from 'containers/Group/Outcome/OutcomeCreatePage/Loadable';
import OutcomeEditPage from 'containers/Group/Outcome/OutcomeEditPage/Loadable';

/* Group - Plan - KPI */
import GroupPlanKpiPage from 'containers/Group/GroupPlan/KPI/KpiPage/Loadable';
import GroupPlanFieldsPage from 'containers/Group/GroupPlan/KPI/FieldsPage/Loadable';
import GroupPlanUpdatesPage from 'containers/Group/GroupPlan/KPI/UpdatesPage/Loadable';
import GroupPlanUpdatePage from 'containers/Group/GroupPlan/KPI/UpdatePage/Loadable';
import GroupPlanUpdateEditPage from 'containers/Group/GroupPlan/KPI/UpdateEditPage/Loadable';
import GroupPlanUpdateCreatePage from 'containers/Group/GroupPlan/KPI/UpdateCreatePage/Loadable';

/* Group - Plan - Budget */
import AnnualBudgetEditPage from 'containers/Group/GroupPlan/AnnualBudget/AnnualBudgetEditPage/Loadable';
import AnnualBudgetsPage from 'containers/Group/GroupPlan/AnnualBudget/AnnualBudgetOverviewPage/Loadable';
import BudgetsPage from 'containers/Group/GroupPlan/Budget/BudgetsPage/Loadable';
import BudgetPage from 'containers/Group/GroupPlan/Budget/BudgetPage/Loadable';
import BudgetRequestPage from 'containers/Group/GroupPlan/Budget/BudgetCreatePage/Loadable';

/* Group - Members */
import GroupMemberListPage from 'containers/Group/GroupMembers/GroupMemberListPage/Loadable';
import GroupMemberCreatePage from 'containers/Group/GroupMembers/GroupMemberCreatePage/Loadable';

/* Group - Manage */
import GroupSettingsPage from 'containers/Group/GroupManage/GroupSettingsPage/Loadable';
import GroupLeadersListPage from 'containers/Group/GroupManage/GroupLeaders/GroupLeadersListPage/Loadable';
import GroupLeaderCreatePage from 'containers/Group/GroupManage/GroupLeaders/GroupLeaderCreatePage/Loadable';
import GroupLeaderEditPage from 'containers/Group/GroupManage/GroupLeaders/GroupLeaderEditPage/Loadable';
import GroupSponsorsListPage from 'containers/Group/GroupManage/GroupSponsors/GroupSponsorsListPage/Loadable';
import GroupSponsorsCreatePage from 'containers/Group/GroupManage/GroupSponsors/GroupSponsorsCreatePage/Loadable';
import GroupSponsorsEditPage from 'containers/Group/GroupManage/GroupSponsors/GroupSponsorsEditPage/Loadable';

/* Group/Admin - Resource */
import FoldersPage from 'containers/Resource/GroupFolder/FoldersPage/Loadable';
import FolderCreatePage from 'containers/Resource/GroupFolder/FolderCreatePage/Loadable';
import FolderEditPage from 'containers/Resource/GroupFolder/FolderEditPage/Loadable';
import FolderPage from 'containers/Resource/GroupFolder/FolderPage/Loadable';
import ResourceCreatePage from 'containers/Resource/GroupResource/ResourceCreatePage/Loadable';
import ResourceEditPage from 'containers/Resource/GroupResource/ResourceEditPage/Loadable';

import EFoldersPage from 'containers/Resource/EnterpriseFolder/FoldersPage/Loadable';
import EFolderCreatePage from 'containers/Resource/EnterpriseFolder/FolderCreatePage/Loadable';
import EFolderEditPage from 'containers/Resource/EnterpriseFolder/FolderEditPage/Loadable';
import EFolderPage from 'containers/Resource/EnterpriseFolder/FolderPage/Loadable';
import EResourceCreatePage from 'containers/Resource/EnterpriseResource/ResourceCreatePage/Loadable';
import EResourceEditPage from 'containers/Resource/EnterpriseResource/ResourceEditPage/Loadable';

/* Admin Innovate */
import CampaignListPage from 'containers/Innovate/Campaign/CampaignListPage/Loadable';
import CampaignCreatePage from 'containers/Innovate/Campaign/CampaignCreatePage/Loadable';
import CampaignEditPage from 'containers/Innovate/Campaign/CampaignEditPage/Loadable';
import CampaignShowPage from 'containers/Innovate/Campaign/CampaignShowPage/Loadable';
import CampaignQuestionListPage from 'containers/Innovate/Campaign/CampaignQuestion/CampaignQuestionListPage/Loadable';
import CampaignQuestionCreatePage from 'containers/Innovate/Campaign/CampaignQuestion/CampaignQuestionCreatePage/Loadable';
import CampaignQuestionEditPage from 'containers/Innovate/Campaign/CampaignQuestion/CampaignQuestionEditPage/Loadable';
import CampaignQuestionShowPage from 'containers/Innovate/Campaign/CampaignQuestion/CampaignQuestionShowPage/Loadable';

/* Global */
import NotFoundPage from 'containers/Shared/NotFoundPage/Loadable';
import PlaceholderPage from 'components/Shared/PlaceholderPage/Loadable';

export {
  ApplicationLayout,
  AuthenticatedLayout,
  SignUpPage,
  UserLayout,
  GroupLayout,
  AdminLayout,
  SessionLayout,
  ResponseLayout,
  ErrorLayout,
  GlobalSettingsLayout,
  LoginPage,
  ForgotPasswordPage,
  HomePage,
  UserGroupListPage,
  AdminGroupListPage,
  GroupCreatePage,
  GroupEditPage,
  GroupCategoriesPage,
  GroupCategoriesCreatePage,
  GroupCategoriesEditPage,
  GroupCategorizePage,
  SegmentListPage,
  SegmentPage,
  FieldsPage,
  UsersPage,
  UsersImportPage,
  UserCreatePage,
  UserEditPage,
  GroupHomePage,
  EventsPage,
  NewsFeedPage,
  EventPage,
  EventCreatePage,
  EventEditPage,
  EventManageMetricsPage,
  GroupPlanEventsPage,
  GroupMessagePage,
  GroupMessageCreatePage,
  GroupMessageEditPage,
  OutcomesPage,
  OutcomeCreatePage,
  OutcomeEditPage,
  GroupPlanKpiPage,
  GroupPlanFieldsPage,
  GroupPlanUpdatesPage,
  GroupPlanUpdatePage,
  GroupPlanUpdateEditPage,
  GroupPlanUpdateCreatePage,
  GroupMemberListPage,
  GroupMemberCreatePage,
  AdminAnnualBudgetPage,
  AnnualBudgetEditPage,
  AnnualBudgetsPage,
  BudgetsPage,
  BudgetPage,
  BudgetRequestPage,
  EventManageLayout,
  EventManageFieldsPage,
  EventManageUpdatesPage,
  EventManageUpdatePage,
  EventManageUpdateEditPage,
  EventManageUpdateCreatePage,
  EventManageExpensesPage,
  EventManageExpenseCreatePage,
  EventManageExpenseEditPage,
  NotFoundPage,
  PlaceholderPage,
  GroupDashboardPage,
  UserDashboardPage,
  MetricsDashboardListPage,
  MetricsDashboardCreatePage,
  MetricsDashboardEditPage,
  MetricsDashboardPage,
  CustomGraphCreatePage,
  CustomGraphEditPage,
  GroupManageLayout,
  GroupPlanLayout,
  GroupKPILayout,
  GroupBudgetLayout,
  GroupLeadersListPage,
  GroupLeaderCreatePage,
  GroupLeaderEditPage,
  GroupSettingsPage,
  GroupSponsorsListPage,
  GroupSponsorsCreatePage,
  GroupSponsorsEditPage,
  CustomTextEditPage,
  UserNewsLinkPage,
  UserEventsPage,
  FoldersPage,
  FolderCreatePage,
  FolderEditPage,
  FolderPage,
  ResourceCreatePage,
  ResourceEditPage,
  EFoldersPage,
  EFolderCreatePage,
  EFolderEditPage,
  EFolderPage,
  EResourceCreatePage,
  EResourceEditPage,
  UserProfilePage,
  InnovateLayout,
  CampaignListPage,
  CampaignCreatePage,
  CampaignEditPage,
  CampaignShowPage,
  CampaignQuestionListPage,
  CampaignQuestionCreatePage,
  CampaignQuestionEditPage,
  CampaignQuestionShowPage,
  PollsList,
  PollCreatePage,
  PollEditPage,
  PollShowPage,
  PollResponsePage,
  EnterpriseConfigurationPage,
  MentorshipProfilePage,
  MentorshipEditProfilePage,
  MentorshipLayout,
  MentorsPage,
  MentorRequestsPage,
  SessionsPage,
  SessionPage,
  SessionsEditPage,
  SystemUserLayout,
  UserRolesListPage,
  UserRoleCreatePage,
  UserRoleEditPage,
  BrandingLayout,
  BrandingThemePage,
  BrandingHomePage,
  SponsorListPage,
  SponsorCreatePage,
  SponsorEditPage,
  SSOSettingsPage,
  EmailsPage,
  EmailEditPage,
  EmailEventsPage,
  EmailEventEditPage,
  EmailLayout,
  PolicyTemplatesPage,
  PolicyTemplateEditPage,
  NewsLinkEditPage,
  NewsLinkCreatePage,
  SocialLinkCreatePage,
  SocialLinkEditPage,
  NewsLinkPage,
  UserDownloadsPage,
  ArchivesPage,
  AdminCalendarPage,
  LogListPage
};
