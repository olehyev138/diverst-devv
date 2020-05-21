import React, { memo, useEffect, useContext } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import reducer from 'containers/Shared/Sponsors/reducer';
import saga from 'containers/Group/GroupManage/GroupSponsors/groupsponsorsSaga';
import {
  createSponsorBegin,
  sponsorsUnmount
} from 'containers/Shared/Sponsors/actions';

import SponsorForm from 'components/Branding/Sponsor/SponsorForm';
import { ROUTES } from 'containers/Shared/Routes/constants';

import messages from 'containers/Branding/messages';
import { injectIntl, intlShape } from 'react-intl';

export function SponsorCreatePage(props) {
  useInjectReducer({ key: 'sponsors', reducer });
  useInjectSaga({ key: 'sponsors', saga });
  const { intl } = props;
  const links = {
    sponsorIndex: ROUTES.group.manage.sponsors.index.path(props.currentGroup.id),
  };

  useEffect(() => () => props.sponsorsUnmount(), []);

  return (
    <React.Fragment>
      <SponsorForm
        sponsorAction={props.createSponsorBegin}
        links={links}
        buttonText={intl.formatMessage(messages.create)}
        sponsorableId={props.currentGroup.id}
      />
    </React.Fragment>
  );
}

SponsorCreatePage.propTypes = {
  intl: intlShape,
  createSponsorBegin: PropTypes.func,
  sponsorsUnmount: PropTypes.func,
  currentGroup: PropTypes.object,
};

const mapStateToProps = createStructuredSelector({
});

const mapDispatchToProps = {
  createSponsorBegin,
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
)(SponsorCreatePage);