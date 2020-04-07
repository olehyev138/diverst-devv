import React, { memo, useEffect, useContext } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import { selectSponsor } from 'containers/Shared/Sponsors/selectors';
import reducer from 'containers/Shared/Sponsors/reducer';
import saga from 'containers/Shared/Sponsors/saga';
import {
  getSponsorBegin,
  updateSponsorBegin,
  sponsorsUnmount
} from 'containers/Shared/Sponsors/actions';

import RouteService from 'utils/routeHelpers';
import SponsorForm from 'components/Branding/Sponsor/SponsorForm';
import { ROUTES } from 'containers/Shared/Routes/constants';

import { injectIntl, intlShape } from 'react-intl';
import messages from 'containers/Branding/messages';

export function GroupSponsorCreatePage(props) {
  useInjectReducer({ key: 'sponsors', reducer });
  useInjectSaga({ key: 'sponsors', saga });

  const rs = new RouteService(useContext);
  const links = {
    sponsorIndex: ROUTES.group.manage.sponsors.index.path(rs.params('group_sponsor_id')),
  };
  const { intl } = props;

  useEffect(() => {
    props.getSponsorBegin({ id: rs.params('group_sponsor_id') });

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
        sponsorableId={rs.params('group_sponsor_id')}
      />
    </React.Fragment>
  );
}

GroupSponsorCreatePage.propTypes = {
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
)(GroupSponsorCreatePage);
