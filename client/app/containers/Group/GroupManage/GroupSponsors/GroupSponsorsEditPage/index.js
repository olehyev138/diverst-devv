import React, { memo, useEffect } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { useParams } from 'react-router-dom';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import { selectSponsor } from 'containers/Shared/Sponsors/selectors';
import reducer from 'containers/Shared/Sponsors/reducer';
import saga from '../groupsponsorsSaga';
import {
  getSponsorBegin,
  updateSponsorBegin,
  sponsorsUnmount
} from 'containers/Shared/Sponsors/actions';

import SponsorForm from 'components/Branding/Sponsor/SponsorForm';
import { ROUTES } from 'containers/Shared/Routes/constants';

import { injectIntl, intlShape } from 'react-intl';
import messages from 'containers/Branding/messages';

export function GroupSponsorEditPage(props) {
  useInjectReducer({ key: 'sponsors', reducer });
  useInjectSaga({ key: 'sponsors', saga });

  const { group_sponsor_id: groupSponsorId } = useParams();
  const { group_id: groupId } = useParams();

  const links = {
    sponsorIndex: ROUTES.group.manage.sponsors.index.path(groupId),
  };
  const { intl } = props;

  useEffect(() => {
    props.getSponsorBegin({ id: groupSponsorId });

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
        sponsorableId={groupId}
      />
    </React.Fragment>
  );
}

GroupSponsorEditPage.propTypes = {
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
)(GroupSponsorEditPage);
