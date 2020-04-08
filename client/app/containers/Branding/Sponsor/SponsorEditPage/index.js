import React, { memo, useEffect, useContext } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';

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

import RouteService from 'utils/routeHelpers';
import SponsorForm from 'components/Branding/Sponsor/SponsorForm';
import { ROUTES } from 'containers/Shared/Routes/constants';

import { injectIntl, intlShape } from 'react-intl';
import messages from 'containers/Branding/messages';

export function SponsorCreatePage(props) {
  useInjectReducer({ key: 'sponsors', reducer });
  useInjectSaga({ key: 'sponsors', saga });

  const rs = new RouteService(useContext);
  const links = {
    sponsorIndex: ROUTES.admin.system.branding.sponsors.index.path(),
  };
  const { intl } = props;
  useEffect(() => {
    props.getSponsorBegin({ id: rs.params('sponsor_id') });

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

SponsorCreatePage.propTypes = {
  intl: intlShape,
  sponsor: PropTypes.object,
  getSponsorBegin: PropTypes.func,
  updateSponsorBegin: PropTypes.func,
  sponsorsUnmount: PropTypes.func
};

const mapStateToProps = createStructuredSelector({
  sponsor: selectSponsor()
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
)(SponsorCreatePage);
