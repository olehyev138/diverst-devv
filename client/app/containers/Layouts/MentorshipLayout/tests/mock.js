// mock store for MentorshipLayout
import React from 'react';
import MentorshipLayout from '../index';
import PropTypes from 'prop-types';

function MockMentorshipLayout(props) {
  return (
    <div>
      <MentorshipLayout {...props} />
    </div>
  );
}

MockMentorshipLayout.propTypes = {
  userSession: PropTypes.object,
  user: PropTypes.object,
  formUser: PropTypes.object,
  classes: PropTypes.object,
  component: PropTypes.elementType,
  pageTitle: PropTypes.object,
};

export default MockMentorshipLayout;
