import React, { memo, useEffect } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { useParams } from 'react-router-dom';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import { selectSponsor } from '../../../Shared/Sponsors/selectors';
import reducer from '../../../Shared/Sponsors/reducer';
import saga from 'containers/Branding/Sponsor/enterprisesponsorsSaga';
import {
  getSponsorBegin,
  updateSponsorBegin,
  sponsorsUnmount
} from '../../../Shared/Sponsors/actions';

import SponsorForm from 'components/Branding/Sponsor/SponsorForm';
import { ROUTES } from 'containers/Shared/Routes/constants';

import { injectIntl, intlShape } from 'react-intl';
import messages from 'containers/Branding/messages';
import Conditional from 'components/Compositions/Conditional';
import { selectPermissions } from 'containers/Shared/App/selectors';
import permissionMessages from 'containers/Shared/Permissions/messages';

export function SponsorEditPage(props) {
  useInjectReducer({ key: 'sponsors', reducer });
  useInjectSaga({ key: 'sponsors', saga });

  const links = {
    sponsorIndex: ROUTES.admin.system.branding.sponsors.index.path(),
  };
  const { intl } = props;

  const { sponsor_id: sponsorId } = useParams();

  useEffect(() => {
    props.getSponsorBegin({ id: sponsorId });

    return () => {
      props.sponsorsUnmount();
    };
  }, []);


  return (
    <React.Fragment>
      <SponsorForm
        sponsor={props.sponsor}
        sponsorAction={props.updateSponsorBegin}
        links={links}
        buttonText={intl.formatMessage(messages.create)}
      />
    </React.Fragment>
  );
}

SponsorEditPage.propTypes = {
  intl: intlShape.isRequired,
  sponsor: PropTypes.object,
  getSponsorBegin: PropTypes.func,
  updateSponsorBegin: PropTypes.func,
  sponsorsUnmount: PropTypes.func
};

const mapStateToProps = createStructuredSelector({
  sponsor: selectSponsor(),
  permissions: selectPermissions(),
});

const mapDispatchToProps = {
  getSponsorBegin,
  updateSponsorBegin,
  sponsorsUnmount
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  injectIntl,
  withConnect,
  memo,
)(Conditional(
  SponsorEditPage,
  ['permissions.branding_manage'],
  (props, params) => props.permissions.adminPath || ROUTES.user.home.path(),
  permissionMessages.branding.sponsor.editPage
));
