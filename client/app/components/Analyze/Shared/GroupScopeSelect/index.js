/**
 *
 * GroupScopeSelect Component
 *
 */

import React, {
  memo, useRef, useState, useEffect
} from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';
import Select from 'react-select';
import { Field, Formik, Form } from 'formik';
import { FormattedMessage } from 'react-intl';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { ROUTES } from 'containers/Shared/Routes/constants';

import messages from 'containers/Analyze/messages';
import { buildValues, mapFields } from 'utils/formHelpers';

import {
  Button, Card, CardActions, CardContent, Grid,
  TextField, Hidden, FormControl
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

const styles = theme => ({
});

/* eslint-disable object-curly-newline */
export function GroupScopeSelectInner({ handleSubmit, handleChange, handleBlur, values, buttonText, setFieldValue, setFieldTouched, ...props }) {
  const groupSelectAction = (searchKey = '') => {
    props.getGroupsBegin({
      count: 10, page: 0, order: 'asc',
      search: searchKey,
    });
  };

  return (
    <Card>
      <Form>
        <CardContent>
          <Select
            name='group_select'
            id='group_select'
            label='Groups'
            menuPortalTarget={document.body}
            isMulti
            options={props.groups}
            value={values.groups}
            onMenuOpen={groupSelectAction}
            onChange={v => setFieldValue('groups', v)}
            onInputChange={value => groupSelectAction(value)}
          />
        </CardContent>
        <CardActions>
          <Button
            color='primary'
            type='submit'
          >
            Refresh
          </Button>
        </CardActions>
      </Form>
    </Card>
  );
}

export function GroupScopeSelect(props) {
  const initialValues = buildValues({}, {
    groups: []
  });

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => props.updateScope(values)}
      render={formikProps => <GroupScopeSelectInner {...props} {...formikProps} />}
    />
  );
}

GroupScopeSelect.propTypes = {
  updateScope: PropTypes.func.isRequired,
};

GroupScopeSelectInner.propTypes = {
  handleSubmit: PropTypes.func,
  handleChange: PropTypes.func,
  handleBlur: PropTypes.func,
  values: PropTypes.object,
  buttonText: PropTypes.string,
  setFieldValue: PropTypes.func,
  setFieldTouched: PropTypes.func,
  classes: PropTypes.object,
  groups: PropTypes.array,
  getGroupsBegin: PropTypes.func
};

export default compose(
  memo,
  withStyles(styles)
)(GroupScopeSelect);
