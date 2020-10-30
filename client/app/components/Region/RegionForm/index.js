/**
 *
 * Region Form Component
 *
 */

import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';
import Select from 'components/Shared/DiverstSelect';
import { Field, Formik, Form } from 'formik';
import { withStyles } from '@material-ui/core/styles';

import { ROUTES } from 'containers/Shared/Routes/constants';

import messages from 'containers/Region/messages';
import { buildValues, mapFields } from 'utils/formHelpers';

import { Card, CardActions, CardContent, TextField, Divider, Typography, Box } from '@material-ui/core';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import DiverstSubmit from 'components/Shared/DiverstSubmit';
import DiverstCancel from 'components/Shared/DiverstCancel';
import DiverstFormLoader from 'components/Shared/DiverstFormLoader';
import DiverstRichTextInput from 'components/Shared/DiverstRichTextInput';

const styles = theme => ({
  noBottomPadding: {
    paddingBottom: '0 !important',
  },
  parentGroupName: {
    color: theme.palette.primary.main,
  },
  firstInput: {
    marginTop: 0,
  },
});

/* eslint-disable object-curly-newline */
export function RegionFormInner({ classes, formikProps, buttonText, parentGroup, ...props }) {
  const { handleSubmit, handleChange, handleBlur, values, setFieldValue, setFieldTouched } = formikProps;

  const parentGroupId = parentGroup && parentGroup.id;

  const groupSelectAction = (searchKey = '') => {
    props.getGroupsBegin({
      count: 10, page: 0, order: 'asc',
      search: searchKey,
      query_scopes: [['non_regioned_children', parentGroupId, values.id || null]]
    });
  };

  return (
    <DiverstFormLoader isLoading={props.isFormLoading} isError={props.edit && !props.region}>
      <Card>
        <Form>
          {parentGroup && (
            <React.Fragment>
              <CardContent>
                <Typography color='textSecondary' variant='h6'>
                  {props.edit ? (
                    <DiverstFormattedMessage {...messages.edit_header} />
                  ) : (
                    <DiverstFormattedMessage {...messages.new_header} />
                  )}
                  &nbsp;
                  <Box component='span' className={classes.parentGroupName}>
                    {parentGroup.name}
                  </Box>
                </Typography>
              </CardContent>
              <Divider />
            </React.Fragment>
          )}
          <CardContent>
            <Field
              component={TextField}
              className={classes.firstInput}
              required
              onChange={handleChange}
              fullWidth
              id='name'
              name='name'
              margin='normal'
              disabled={props.isCommitting}
              label={<DiverstFormattedMessage {...messages.name} />}
              value={values.name}
            />
            <Field
              component={TextField}
              onChange={handleChange}
              fullWidth
              id='short_description'
              name='short_description'
              margin='normal'
              disabled={props.isCommitting}
              value={values.short_description}
              label={<DiverstFormattedMessage {...messages.short_description} />}
            />
            <Field
              component={DiverstRichTextInput}
              onChange={value => setFieldValue('description', value)}
              fullWidth
              id='description'
              name='description'
              margin='normal'
              label={<DiverstFormattedMessage {...messages.description} />}
              value={values.description}
            />
          </CardContent>
          <Divider />
          <CardContent>
            <Select
              id='child_ids'
              name='child_ids'
              label={<DiverstFormattedMessage {...messages.children} />}
              fullWidth
              isMulti
              options={props.selectGroups}
              value={values.child_ids}
              onInputChange={value => groupSelectAction(value)}
              onChange={value => setFieldValue('child_ids', value)}
            />
          </CardContent>
          <Divider />
          <CardActions>
            <DiverstSubmit isCommitting={props.isCommitting}>
              {buttonText}
            </DiverstSubmit>
            <DiverstCancel
              disabled={props.isCommitting}
              redirectFallback={
                parentGroupId
                  ? ROUTES.admin.manage.groups.regions.index.path(parentGroupId)
                  : ROUTES.admin.manage.groups.index.path()
              }
            >
              <DiverstFormattedMessage {...messages.cancel} />
            </DiverstCancel>
          </CardActions>
        </Form>
      </Card>
    </DiverstFormLoader>
  );
}

export function RegionForm(props) {
  const initialValues = buildValues(props.region, {
    id: { default: '' },
    private: { default: false },
    name: { default: '' },
    short_description: { default: '' },
    description: { default: '' },
    parent: { default: '', customKey: 'parent_id' },
    children: { default: [], customKey: 'child_ids' }
  });

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        if (values.child_ids == null)
          values.child_ids = [];
        props.regionAction(mapFields(values, ['child_ids', 'parent_id']));
      }}
    >
      {formikProps => <RegionFormInner {...props} formikProps={formikProps} />}
    </Formik>
  );
}

RegionForm.propTypes = {
  edit: PropTypes.bool,
  regionAction: PropTypes.func,
  region: PropTypes.object,
  parentGroup: PropTypes.object,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
};

RegionFormInner.propTypes = {
  formikProps: PropTypes.shape({
    handleSubmit: PropTypes.func,
    handleChange: PropTypes.func,
    handleBlur: PropTypes.func,
    values: PropTypes.object,
    setFieldValue: PropTypes.func,
    setFieldTouched: PropTypes.func,
  }),
  edit: PropTypes.bool,
  region: PropTypes.object,
  parentGroup: PropTypes.object,
  parentGroupId: PropTypes.number,
  classes: PropTypes.object,
  buttonText: PropTypes.string,
  selectGroups: PropTypes.array,
  getGroupsBegin: PropTypes.func,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
};

export default compose(
  memo,
  withStyles(styles)
)(RegionForm);
